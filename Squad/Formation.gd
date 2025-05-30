extends Node2D
class_name Formation

# Formation mapping: unit -> position
var formation_assignments: Dictionary = {} # {Unit: Vector2}
@export var spacing: float = 50.0
@export var padding: float = 50.0

func _ready():
    var parent_data = get_parent()
    var units = parent_data.get_units()
    
    if formation_assignments.is_empty():
        calculate_formation(units)

func calculate_formation(units: Array[Unit]):
    var cols = int(ceil(sqrt(units.size())))
    
    for i in units.size():
        var position = Vector2(
            (i % cols) * spacing,
            (i / cols) * spacing
        )
        formation_assignments[units[i]] = position

func get_border(active_unit_only: bool = false) -> Rect2:
    if formation_assignments.is_empty():
        return Rect2()
    
    var positions: Array
    if active_unit_only:
        for unit in formation_assignments.keys().filter(func(unit: Unit): return !unit.is_removable and !unit.is_removing):
            positions.append(formation_assignments[unit])
    else:
        positions = formation_assignments.values()
    
    var min_pos = positions[0]
    var max_pos = positions[0]
    
    for pos in positions:
        min_pos.x = min(min_pos.x, pos.x)
        min_pos.y = min(min_pos.y, pos.y)
        max_pos.x = max(max_pos.x, pos.x)
        max_pos.y = max(max_pos.y, pos.y)
    
    return Rect2(min_pos, max_pos - min_pos).grow(padding)

func apply_formation(offset: Vector2 = Vector2.ZERO) -> void:
    var parent_data = get_parent()
    var units = parent_data.get_units()
    
    for unit in units:
        if not formation_assignments.has(unit):
            continue
            
        unit.position = formation_assignments[unit] + offset
