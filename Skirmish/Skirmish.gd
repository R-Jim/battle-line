extends Node
class_name Skirmish

@onready var _unit_manager: UnitManager = $UnitManager
@export var cycle_time: float = 5.0
@onready var melee_zone = $MeleeZone

var cycle_timer: Timer
var phases = [&"Strategic", &"Ranged", &"Melee"]
var _is_skirmish_completed: bool

var unit_position_reset = Vector2(-1000, -1000)

# test only
@export var preset_squads: Array[Squad] = []

var squads: Dictionary[Squad, bool] = {}

func _ready() -> void:
    cycle_timer = Timer.new()
    cycle_timer.wait_time = cycle_time
    cycle_timer.timeout.connect(_end_cycle)
    cycle_timer.autostart = true
    add_child(cycle_timer)
    
    for squad in preset_squads:
        squad_join(squad)
        squad.get_parent().remove_child(squad)

func squad_join(squad: Squad):
    squad.visible = false
    squad.in_skirmish = true
    squads[squad] = true
    for unit: Unit in squad.get_units():
        if unit.get_parent():
            unit.get_parent().remove_child(unit)
        unit.position = unit_position_reset
        _unit_manager.add_child(unit)


func squad_return(squad: Squad):
    for unit: Unit in squad.get_units():
        _unit_manager.unregister_unit(unit)
    squad.visible = true
    squad.in_skirmish = false
    squads.erase(squad)
    
func is_skirmish_complete() -> bool:
    return _is_skirmish_completed


func _end_cycle():
    for unit: Unit in _unit_manager.registered_units:
        unit.property.start_session()
    
    process_squad_formations_move_to_melee()
    #process_phase(&"Strategic")
    #process_phase(&"Ranged")
    process_phase(&"Melee")
    
    for unit: Unit in _unit_manager.registered_units:
        unit.property.commit_session()
        
    if _unit_manager.registered_units.size() == 0:
        _is_skirmish_completed = true

func process_phase(phase: StringName) -> void:
    process_units_melee_toggle()
    _unit_manager.process_all_units(phase)

func process_squad_formations_move_to_melee() -> void:
    var player_squads = squads.keys().filter(func(squad: Squad): return squad.get_faction() > 0)
    var enemy_squads = squads.keys().filter(func(squad: Squad): return squad.get_faction() < 0)
    
    var current_y_offset = 0.0
    for squad: Squad in player_squads:
        var offset: Vector2
        var formation_border = squad.formation.get_border(true)
        offset.x = melee_zone.position.x - formation_border.position.x
        offset.y = melee_zone.position.y + current_y_offset
        squad.formation.apply_formation(offset)
        current_y_offset += squad.formation.get_border(true).size.y

    current_y_offset = 0.0
    for squad in enemy_squads:
        var offset: Vector2
        var formation: Formation = squad.formation
        var formation_border = formation.get_border(true)
        offset.y = melee_zone.position.y + current_y_offset
        offset.x = melee_zone.position.x - formation_border.size.x - formation_border.position.x
        formation.apply_formation(offset)
        current_y_offset += formation_border.size.y

func process_units_melee_toggle() -> void:
    for unit: Unit in _unit_manager.registered_units:
        unit.property.set_property("in_melee", is_unit_inside_polygon(melee_zone, unit))

func is_unit_inside_polygon(polygon_node: Polygon2D, target_node: Unit) -> bool:
    var global_polygon_points = []
    var polygon = polygon_node.polygon
    var offset = polygon_node.offset

    # Apply polygon offset before converting to global coordinates
    for point in polygon:
        var offset_point = point + offset
        global_polygon_points.append(polygon_node.to_global(offset_point))

    # Get the global position of the target node
    var point_to_check = target_node.global_position

    # Check if the point is inside the polygon
    return Geometry2D.is_point_in_polygon(point_to_check, global_polygon_points)
