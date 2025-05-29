extends Node


@export var cycle_time: float = 5.0
@onready var _unit_manager: UnitManager = $UnitManager
@export var melee_zone: Polygon2D

var cycle_timer: Timer
var phases = [&"Strategic", &"Ranged", &"Melee"]

func _ready() -> void:
    cycle_timer = Timer.new()
    cycle_timer.wait_time = cycle_time
    cycle_timer.timeout.connect(_end_cycle)
    cycle_timer.autostart = true
    add_child(cycle_timer)


func _end_cycle():
    for unit: Unit in _unit_manager.registered_units:
        unit.property.start_session()
    
    #process_phase(&"Strategic")
    #process_phase(&"Ranged")
    process_phase(&"Melee")
    
    for unit: Unit in _unit_manager.registered_units:
        unit.property.commit_session()

func process_phase(phase: StringName) -> void:
    process_units_melee_toggle()
    _unit_manager.process_all_units(phase)

func process_units_melee_toggle() -> void:
    for unit: Unit in _unit_manager.registered_units:
        unit.property.set_property("in_melee", is_unit_inside_polygon(melee_zone, unit))

func is_unit_inside_polygon(polygon_node: Polygon2D, target_node: Unit) -> bool:
    var global_polygon_points = []
    var polygon = polygon_node.polygon

    # Convert local polygon points to global coordinates
    for point in polygon:
        global_polygon_points.append(polygon_node.to_global(point))

    # Get the global position of the target node
    var point_to_check = target_node.global_position

    # Check if the point is inside the polygon
    return Geometry2D.is_point_in_polygon(point_to_check, global_polygon_points)
