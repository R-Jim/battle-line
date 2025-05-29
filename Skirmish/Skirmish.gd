extends Node
class_name Skirmish

@onready var _unit_manager: UnitManager = $CycleManager/UnitManager

var _is_skirmish_completed: bool

func _ready() -> void:
    pass
    

func squad_join(squad: Squad):
    squad.visible = false
    squad.in_skirmish = true

func squad_return(squad: Squad):
    for unit: Unit in squad.get_units():
        if unit.get_parent() == _unit_manager:
            _unit_manager.remove_child(unit)
    squad.visible = true
    squad.in_skirmish = false
    
func is_skirmish_complete() -> bool:
    return _is_skirmish_completed
