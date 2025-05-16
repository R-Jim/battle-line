extends Panel

@export var _squad: Squad
@onready var squad_name = $SquadName

@onready var unit_slots: Array = [$Units/Slot0, $Units/Slot1, $Units/Slot2, $Units/Slot3]
@onready var commander_unit_slot = $CommanderUnit

func _ready() -> void:
    if not _squad:
        return
    
    set_squad(_squad)
    

func set_squad(squad: Squad) -> void:
    _squad = squad
    squad_name.set("text", _squad.name)
    
    if squad.commander_unit:
        commander_unit_slot.set_unit(squad.commander_unit)
    else:
        commander_unit_slot.set_unit(null)
    
    for slot_index in range(unit_slots.size()):
        var unit_slot = unit_slots[slot_index]
        if slot_index >= squad.units.size():
            unit_slot.set_unit(null)    
        else:
            unit_slot.set_unit(squad.units[slot_index])
        
    
    
