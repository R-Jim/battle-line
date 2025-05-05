extends CharacterBody2D
class_name Squad

# Export variables for configuration
@export var squad_faction: int = 0
@export var units: Array[Unit] = []

# Preloaded node references
@onready var skirmish_area = $SkirmishArea
@onready var selectable = $Selectable
@onready var command = $Command

@export var speed: int = 20

# Variables for tracking nearby squads
var nearby_squads = []
var destination: Vector2
var in_skirmish = false
var push_velocity: Vector2 = Vector2.ZERO
var max_velocity = speed
var push_decay: float = 180.0
var push_strength = 10

# Called when the node enters the scene tree
func _ready():
    # Connect signals
    skirmish_area.connect("area_entered", Callable(self, "_on_area_entered"))
    skirmish_area.connect("area_exited", Callable(self, "_on_area_exited"))

# Called every frame
func _process(delta):
    check_for_skirmish()
    

func _physics_process(delta):
    velocity = Vector2.ZERO
    
    # Movement toward destination
    if destination != Vector2.ZERO:
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
            collider.apply_push(push_dir*push_strength)
        
func apply_push(force: Vector2):
    push_velocity += force


# When another area enters this squad's detection range
func _on_area_entered(area):
    var parent = area.get_parent()
    if parent is Squad and parent != self:
        if not nearby_squads.has(parent):
            nearby_squads.append(parent)

# When another area exits this squad's detection range
func _on_area_exited(area):
    var parent = area.get_parent()
    if parent is Squad:
        if nearby_squads.has(parent):
            nearby_squads.erase(parent)
            
    # If we're no longer in range of any squads, end skirmish
    if nearby_squads.size() < 1 and in_skirmish:
        end_skirmish()

# Check if conditions for skirmish are met
func check_for_skirmish():
    # If 2 or more squads (including this one) are in range, start skirmish
    if nearby_squads.size() >= 1 and not in_skirmish:
        start_skirmish()

# Start skirmish between squads
func start_skirmish():
    in_skirmish = true
    print("Skirmish started between " + str(nearby_squads.size() + 1) + " squads")
    
    # Call skirmish function
    skirmish()

# End skirmish
func end_skirmish():
    in_skirmish = false
    print("Skirmish ended")

# Skirmish logic - override this in child classes for custom behavior
func skirmish():
    print("Squad " + name + " is in a skirmish with:")
    
    for squad in nearby_squads:
        print("- " + squad.name + " (Faction: " + str(squad.squad_faction) + ")")
    
    # Example battle logic
    var hostile_squads = []
    for squad in nearby_squads:
        if squad.squad_faction * squad_faction < 0:
            hostile_squads.append(squad)
    
    if hostile_squads.size() > 0:
        print(name + " engaging hostile squads!")
        # Implement battle logic here
    else:
        print("All squads are friendly or neutral. No combat.")

# Visual representation handled by UI
