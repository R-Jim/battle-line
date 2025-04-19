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
@onready var waypoint_flag = $Flag

@onready var animation_player = $AnimationPlayer
@onready var animation_tree = $AnimationTree
@onready var state_machine = animation_tree["parameters/playback"]

var push_velocity: Vector2 = Vector2.ZERO
var max_velocity = speed
var push_decay: float = 180.0
var remove_destination_timer: Timer

func _ready():
    property.new_property({"health": max_health, "attack": max_attack, "speed": speed, "push_strength": 3, "faction": faction, "destination": Vector2.ZERO, "is_move": false})
    UnitManager._register_unit(self, id)
    
    
    if property.get_property("faction") > 0:
        sprite["flip_h"] = true
    

    update_health_bar()
    remove_destination_timer = Timer.new()
    remove_destination_timer.one_shot = true
    remove_destination_timer.timeout.connect(_remove_destination)
    add_child(remove_destination_timer)

func _process(_delta: float) -> void:
    update_health_bar()
    queue_redraw()

    var destination = property.get_property("destination")
    if destination == Vector2.ZERO || !property.get_property("is_move"):
        animation_tree["parameters/conditions/is_moving"] = false
        animation_tree["parameters/conditions/is_idle"] = true
    else:  # No destination set
        animation_tree["parameters/conditions/is_moving"] = true
        animation_tree["parameters/conditions/is_idle"] = false		


func _physics_process(delta):
    velocity = Vector2.ZERO
    if !property.get_property("is_move"):
        remove_destination_timer.paused = true
    else:
        remove_destination_timer.paused = false
    
    # Movement toward destination
    var destination = property.get_property("destination")
    if destination != Vector2.ZERO && property.get_property("is_move"):
        var direction = (destination - global_position).normalized()
        var distance = speed * delta

        if global_position.distance_to(destination) > distance:
            velocity = direction * speed
            @warning_ignore("integer_division")
            var expected_traverse_time = ceil(global_position.distance_to(destination)/(speed/5)) + 2
            if remove_destination_timer.is_stopped() or remove_destination_timer.time_left > expected_traverse_time:
                remove_destination_timer.start(expected_traverse_time)
            
        else:
            global_position = destination
            property.set_property("destination", Vector2.ZERO)

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

func _draw() -> void:
    var destination = property.get_property("destination")
    
    if destination != Vector2.ZERO:
        waypoint_flag["visible"] = true
        waypoint_flag["global_position"] = destination
        draw_dashed_line(sprite.position, waypoint_flag.position, Color.BLUE, 3.0, 5.0)
    else:
        waypoint_flag["visible"] = false


func _receive_action_noti(action: String, _isTarget: bool):
    state_machine.travel(action)

func update_health_bar():
    if health_bar:
        health_bar.value = float(property.get_property("health")) / max_health * 100

func _confirm_registration():
    print("Unit[", id, "] registered successfully.")

func _get_skills(phase: StringName) -> Array[Skill]:
    var skills: Array[Skill] = []
    for child in get_children():
        if child is Skill and child._get_phase() == phase:
            skills.append(child)
    return skills

func _remove():
    state_machine.travel("die")

func _remove_destination():
    property.set_property("destination", Vector2.ZERO)
