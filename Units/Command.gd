extends Node2D

@export var source: Unit

@onready var waypoint_flag = $Flag

var is_pause: bool

var is_move: bool
var command_color: Color

var destination: Vector2
var remove_destination_timer: Timer

func _ready():
    remove_destination_timer = Timer.new()
    remove_destination_timer.one_shot = true
    remove_destination_timer.timeout.connect(_remove_destination)
    add_child(remove_destination_timer)

func _process(_delta: float) -> void:
    if is_pause:
        remove_destination_timer.paused = true
        return
    else:
        remove_destination_timer.paused = false
    
    if is_move && destination != Vector2.ZERO:
        if source.position == destination:
            _remove_destination()
            return
            
        @warning_ignore("integer_division")
        var expected_traverse_time = ceil(global_position.distance_to(destination)/(source.property.get_property("speed")/5)) + 2
        if remove_destination_timer.time_left > expected_traverse_time:
            remove_destination_timer.start(expected_traverse_time)
            
        command_color = Color.BLUE
        source.destination = destination
        queue_redraw()
        
        

func _draw() -> void:
    if destination != Vector2.ZERO:
        waypoint_flag["visible"] = true
        waypoint_flag["global_position"] = destination
        draw_dashed_line(self.position, waypoint_flag.position, command_color, 3.0, 5.0)
    else:
        waypoint_flag["visible"] = false


func _remove_destination():
    destination = Vector2.ZERO
    is_move = false
