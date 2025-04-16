extends CharacterBody2D
class_name Unit

@export var unit_id = "unit_000"
@export var max_health = 100
@export var max_attack = 10
@export var speed = 100
@export var push_strenght = 3
@export var faction = 1

@export var destination: Vector2 = Vector2.ZERO

@onready var properties = {"health": max_health, "attack": max_attack, "faction": faction, "destination": destination, "is_move": false}

@onready var health_bar = $HealthBar
@onready var sprite = $Sprite2D
@onready var waypoint_flag = $Flag

@onready var animation_player = $AnimationPlayer
@onready var animation_tree = $AnimationTree
@onready var state_machine = animation_tree["parameters/playback"]

var push_velocity: Vector2 = Vector2.ZERO
var push_decay: float = 180.0

func _ready():
	UnitManager._register_unit(self, unit_id, properties)
	
	if faction > 0:
		sprite["flip_h"] = true

	update_health_bar()

func _process(delta: float) -> void:
	update_health_bar()
	queue_redraw()

	destination = properties["destination"]
	if destination == Vector2.ZERO || !properties["is_move"]:
		animation_tree["parameters/conditions/is_moving"] = false
		animation_tree["parameters/conditions/is_idle"] = true
	else:  # No destination set
		animation_tree["parameters/conditions/is_moving"] = true
		animation_tree["parameters/conditions/is_idle"] = false		


func _physics_process(delta):
	velocity = Vector2.ZERO

	# Movement toward destination
	if destination != Vector2.ZERO && properties["is_move"]:
		var direction = (destination - global_position).normalized()
		var distance = speed * delta

		if global_position.distance_to(destination) > distance:
			velocity = direction * speed
		else:
			global_position = destination
			properties["destination"] = Vector2.ZERO

	# Apply push velocity
	if push_velocity.length() > 0.1:
		velocity += push_velocity
		push_velocity = push_velocity.move_toward(Vector2.ZERO, push_decay * delta)
	else:
		push_velocity = Vector2.ZERO

	# Skip movement if not needed
	if velocity == Vector2.ZERO:
		return

	# Move and check collisions
	move_and_slide()

	for i in range(get_slide_collision_count()):
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()

		if collider is CharacterBody2D and collider.has_method("apply_push"):
			var push_dir = (collider.global_position - global_position).normalized()
			collider.apply_push(push_dir*push_strenght)
		
func apply_push(force: Vector2):
	push_velocity += force

func _draw() -> void:
	var destination = properties["destination"]
	
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
		health_bar.value = float(properties["health"]) / max_health * 100

func _confirm_registration():
	print("Unit[", unit_id, "] registered successfully.")

func _get_skills(_phase: String) -> Array:
	var skills = []
	for child in get_children():
		if child is Area2D and child.name.begins_with("Skill"):
			skills.append(child)
	return skills

func _remove():
	state_machine.travel("die")
