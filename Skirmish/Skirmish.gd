extends Node
class_name Skirmish

@onready var _selectable_tilemap = $SelectableTileMap
@onready var _unit_manager = $CycleManager/UnitManager
@onready var _structure_manger = $CycleManager/StructureManager

const default_commander = preload("res://Skirmish/Commander.gd")

var commanders: Dictionary[int, Commander] = {}

func commander_register(commander: Commander):
    commander._unit_manager = _unit_manager
    commander._structure_manager = _structure_manger
    commanders[commander.get_faction()] = commander
    add_child(commander)
    print("commander joined")


func squad_join(squad: Squad):
    if not commanders.has(squad.get_faction()):
        print("no commander for faction:", squad.get_faction())
        var commander = default_commander.new()
        commander._faction = squad.get_faction()
        commander.name = "DefaultCommander[%d]" % squad.get_faction()
        commander_register(commander)

    
    var commander = commanders[squad.get_faction()]
    commander.deployable_units.append_array(squad.units)
    print("squad joined")
