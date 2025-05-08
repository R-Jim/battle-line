extends Node
class_name Skirmish

@onready var _selectable_tilemap = $SelectableTileMap
@onready var _unit_manager: UnitManager = $CycleManager/UnitManager
@onready var _structure_manger: StructureManager = $CycleManager/StructureManager

const default_commander = preload("res://Skirmish/Commander.gd")

var commanders: Dictionary[int, Commander] = {}

var _is_skirmish_completed: bool
var skirmish_complete_timer: Timer

func _ready() -> void:
    skirmish_complete_timer = Timer.new()
    skirmish_complete_timer.one_shot = true
    skirmish_complete_timer.timeout.connect(_skirmish_complete)
    add_child(skirmish_complete_timer)
    
func _process(delta: float) -> void:
    if _unit_manager.registered_units.size() == 0:
        if skirmish_complete_timer.is_stopped():
            skirmish_complete_timer.start(10)
    else:
        if not skirmish_complete_timer.is_stopped():
            skirmish_complete_timer.stop()

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

func squad_return(squad: Squad):
    for unit: Unit in squad.units:
        _unit_manager.remove_child(unit)
        squad.add_child(unit)
    
func is_skirmish_complete() -> bool:
    return _is_skirmish_completed

func _skirmish_complete():
    _is_skirmish_completed = true
