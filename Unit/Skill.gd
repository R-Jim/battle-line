extends Node
class_name Skill

@onready var self_unit: Unit = get_parent()

@export_enum(&"Strategic", &"Ranged", &"Melee")
var _active_phase_string: String
var _active_phase: StringName
@export var skill_id: StringName = &"default_melee"
@export var number_of_targets: int = 1

var _target_interactions: Dictionary # Dictionary[Unit, Array[Dictionary[property_string, value]]]

func _ready() -> void:
    _active_phase = _active_phase_string

func process_targets(units: Array[Unit]) -> void:
    _target_interactions = {}
    
    var filtered_units = units.filter(func (unit: Unit): return unit.property.get_property("in_melee") and self_unit.property.get_property("faction") * unit.property.get_property("faction") < 0)
    var sorted_units = filtered_units.slice(0, number_of_targets)
    
    for unit in sorted_units:
        if not _target_interactions.has(unit):
            _target_interactions[unit] = []
        
        _target_interactions[unit].append({
            "health": -50,
        })

func get_target_interactions() -> Dictionary:
    return _target_interactions.duplicate()
    
