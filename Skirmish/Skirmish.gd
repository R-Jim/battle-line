extends Node
class_name Skirmish

@onready var _selectable_tilemap = $SelectableTileMap
@onready var _unit_manager = $CycleManager/UnitManager
@onready var _structure_manger = $CycleManager/StructureManager

var commanders: Dictionary[int, Commander] = {}

func commander_register(commander: Commander):
    commanders[commander.get_faction()] = commander
    print("commander joined")


func squad_join(squad: Squad):
    if not commanders.has(squad.get_faction()):
        print("no commander for faction:", squad.get_faction())
        for unit in squad.units:
            _unit_manager.add_child(unit)
        return
    
    var commander = commanders[squad.get_faction()]
    commander.deployable_units.append_array(squad.units)
    print("squad joined")
