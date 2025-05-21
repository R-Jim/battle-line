extends CharacterBody2D
class_name Squad

# Export variables for configuration
@export var _faction: int = 0
@export var _units: Array[Unit] = []

# Preloaded node references
@onready var skirmish_area = $SkirmishArea
@onready var selectable = $Selectable
@onready var command = $Command
@export var commander_unit: Unit

@export var speed: int = 20

# Variables for tracking nearby squads
var nearby_hostile_squads = []
var destination: Vector2
var is_skirmish_ready: bool
var in_skirmish = false
var push_velocity: Vector2 = Vector2.ZERO
var max_velocity = speed
var push_decay: float = 180.0
var push_strength = 10
var max_movement = 0

# Variables for influence
@export var influence_strength = 5

var _squad_effects: Dictionary[SquadEffect, bool] = {}

# Called when the node enters the scene tree
func _ready():
    if skirmish_area: 
        # Connect signals
        skirmish_area.connect("area_entered", Callable(self, "_on_area_entered"))
        skirmish_area.connect("area_exited", Callable(self, "_on_area_exited"))


    for child in get_children():
        if child is SquadEffect:
            add_effect(child)


# Called every frame
func _process(_delta):
    is_skirmish_ready = false
    for unit in _units:
        if unit.property.get_property("health") > 0:
            is_skirmish_ready = true
            break
    if not in_skirmish and not is_skirmish_ready:
        get_parent().remove_child(self)

func _physics_process(delta):
    velocity = Vector2.ZERO
    if in_skirmish or max_movement <= 0:
        return
    
    # Movement toward destination
    if destination != Vector2.ZERO:
        var direction = (destination - global_position).normalized()
        var distance = speed * delta

        if global_position.distance_to(destination) > distance:
            velocity = direction * speed
            max_movement -= distance
        else:
            global_position = destination
            destination = Vector2.ZERO

    # Apply push velocity
    if push_velocity.length() > 0.1:
        velocity += push_velocity
        push_velocity = push_velocity.move_toward(Vector2.ZERO, push_decay * delta)
    else:
        push_velocity = Vector2.ZERO

    # Skip movement if not needed
    if velocity == Vector2.ZERO:
        return

    velocity = velocity.limit_length(max_velocity)
    # Move and check collisions
    move_and_slide()

    for i in range(get_slide_collision_count()):
        var collision = get_slide_collision(i)
        var collider = collision.get_collider()

        if collider is CharacterBody2D and collider.has_method("apply_push"):
            var push_dir = (collider.global_position - global_position).normalized()
            collider.apply_push(push_dir*push_strength)
        
func apply_push(force: Vector2):
    push_velocity += force


# When another area enters this squad's detection range
func _on_area_entered(area):
    var parent = area.get_parent()
    if parent is Squad and parent != self and parent._faction * _faction < 0:
        nearby_hostile_squads.append(parent)

# When another area exits this squad's detection range
func _on_area_exited(area):
    var parent = area.get_parent()
    if parent is Squad:
        if nearby_hostile_squads.has(parent):
            nearby_hostile_squads.erase(parent)


func get_faction() -> int:
    return _faction

func reset_movement() -> void:
    max_movement = speed * 3

func add_effect(effect: SquadEffect) -> void:
    _squad_effects[effect] = true
    add_child(effect)
    var unit_effects = effect.get_unit_effects()
    if unit_effects.size() == 0:
        return
    
    for unit in _units:
        for unit_effect in unit_effects:
            var ue = unit_effect.duplicate()
            unit.add_child(ue)
    if commander_unit:
        for unit_effect in unit_effects:
            var ue = unit_effect.duplicate()
            commander_unit.add_child(ue)

func get_units() -> Array[Unit]:
    var units = _units.duplicate()
    if commander_unit:
        units.push_front(commander_unit)
    
    return units
