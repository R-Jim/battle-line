extends Node
class_name Skirmish

@onready var _selectable_tilemap = $SelectableTileMap
@onready var _unit_manager: UnitManager = $CycleManager/UnitManager
@onready var _structure_manger: StructureManager = $CycleManager/StructureManager

# Export deployment zones
@export var faction_minus_one_zones: Array[DeploymentZone] = []
@export var faction_one_zones: Array[DeploymentZone] = []

# Dictionary for easier access during runtime
var deployment_zones = {}

const default_commander = preload("res://Skirmish/Commander.gd")

var commanders: Dictionary[int, Commander] = {}

var _is_skirmish_completed: bool

func _ready() -> void:
    deployment_zones = {
        -1: faction_minus_one_zones,
        1: faction_one_zones
    }
    
    for commander: Commander in commanders.values():
        commander._unit_manager = _unit_manager
        commander._structure_manager = _structure_manger
    
func _process(delta: float) -> void:
    if _unit_manager.registered_units.size() == 0:
        for commander: Commander in commanders.values():
            if commander.deployable_units.size() > 0:
                return
        _is_skirmish_completed = true

func commander_register(commander: Commander):
    commanders[commander.get_faction()] = commander
    add_child(commander)


func squad_join(squad: Squad):
    if not commanders.has(squad.get_faction()):
        print("no commander for faction:", squad.get_faction())
        var commander = default_commander.new()
        commander._faction = squad.get_faction()
        commander.name = "DefaultCommander[%d]" % squad.get_faction()
        commander_register(commander)

    
    var commander = commanders[squad.get_faction()]
    commander.deployable_units.append_array(squad.get_units())
    squad.visible = false
    squad.in_skirmish = true

func squad_return(squad: Squad):
    for unit: Unit in squad.get_units():
        _unit_manager.remove_child(unit)
    squad.visible = true
    squad.in_skirmish = false
    
func is_skirmish_complete() -> bool:
    return _is_skirmish_completed

func get_available_deployment_zones(faction: int) -> Array[DeploymentZone]:
  if not faction in deployment_zones:
    return []

  var deployable_zones: Array[DeploymentZone] = []
  var zones = deployment_zones[faction]
  for zone in zones:
    if not zone.is_occupied():
      deployable_zones.append(zone)
  
  return deployable_zones
