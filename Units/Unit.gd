extends CharacterBody2D
class_name Unit

@export var id = "unit_000"
@export var max_health = 100
@export var max_attack = 10
@export var speed = 50
@export var faction = 1

@onready var property: Property = $Property

@onready var health_bar = $HealthBar
@onready var sprite = $Sprite2D

@onready var animation_player = $AnimationPlayer
@onready var animation_tree = $AnimationTree
@onready var state_machine = animation_tree["parameters/playback"]
@onready var selectable = $Selectable
@onready var command = $Command

var push_velocity: Vector2 = Vector2.ZERO
var destination: Vector2
var max_velocity = speed
var push_decay: float = 180.0

func _ready():
    property.new_property({
        "health": PropertyStruct.new(max_health, max_health),
        "attack": PropertyStruct.new(max_attack),
        "speed": PropertyStruct.new(speed),
        "push_strength": PropertyStruct.new(3),
        "faction": PropertyStruct.new(faction),
        "is_move": PropertyStruct.new(false),
    })
    
    if property.get_property("faction") > 0:
        sprite["flip_h"] = true
    

    update_health_bar()


func _process(_delta: float) -> void:
    update_health_bar()
    queue_redraw()

    if destination == Vector2.ZERO || !property.get_property("is_move"):
        animation_tree["parameters/conditions/is_moving"] = false
        animation_tree["parameters/conditions/is_idle"] = true
    else:  # No destination set
        animation_tree["parameters/conditions/is_moving"] = true
        animation_tree["parameters/conditions/is_idle"] = false		


func _physics_process(delta):
    velocity = Vector2.ZERO
    
    # Movement toward destination
    if destination != Vector2.ZERO && property.get_property("is_move"):
        var direction = (destination - global_position).normalized()
        var distance = speed * delta

        if global_position.distance_to(destination) > distance:
            velocity = direction * speed
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
            var push_strength = property.get_property("push_strength")
            collider.apply_push(push_dir*push_strength)
        
func apply_push(force: Vector2):
    push_velocity += force

func _receive_action_noti(action: String, _isTarget: bool):
    state_machine.travel(action)

func update_health_bar():
    if health_bar:
        health_bar.value = float(property.get_property("health")) / max_health * 100

func _get_skills(phase: StringName) -> Array[Skill]:
    var skills: Array[Skill] = []
    for child in get_children():
        if child is Skill and child._get_phase() == phase:
            skills.append(child)
    return skills

func _remove():
    state_machine.travel("die")

func remove_from_parent():
    if get_parent():
        get_parent().remove_child(self)
