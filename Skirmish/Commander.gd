extends Node
class_name Commander

@export var _unit_manager: UnitManager
@export var _structure_manager: StructureManager

@export var _faction: int
@export_enum(&"capture", &"attack") var _objective_types: Array[String] = []
var _objectives: Array[Objective] = []

@export var deployable_units: Array[Unit]
var commandable_units: Array[Unit] = []
var commandable_structures: Array[Castle] = []

func _ready() -> void:
  for objective_type in _objective_types:
    var objective = Objective.new()
    objective.set_type(objective_type)
    _objectives.append(objective)
  
  for unit in _unit_manager.get_units():
    if unit.property.get_property("faction") == _faction:
      commandable_units.append(unit)
    
  for structure in _structure_manager.get_structures():
    if structure.property.get_property("faction") == _faction:
      commandable_structures.append(structure)

  GameMaster._register_faction_commander(_faction, self)

func _process(_delta):
  var pending_objectives = _objectives.filter(_is_objective_pending)
  
  for objective in pending_objectives:
      _process_objective(objective)

func _process_objective(objective: Objective) -> void:
  if objective.get_type() == "capture":
    if _structure_manager.registered_structures.values().filter(_is_castle).size() > 0 and _structure_manager.registered_structures.values().filter(func(n): return _is_castle(n) && _is_enemy(n)).size() == 0:
      objective.mark_complete()
  return

func command_units() -> void:
  commandable_units = commandable_units.filter(func(unit): return unit != null)

  var pending_objectives = _objectives.filter(_is_objective_pending)
  if pending_objectives.size() == 0:
    return

  var objective = pending_objectives[0]
  if objective.get_type() == "capture":
    _command_units_capture()
  
func _command_units_capture() -> void:
  var enemy_castles = _structure_manager.registered_structures.values().filter(func(n): return _is_castle(n) && _is_enemy(n))
  if enemy_castles.size() == 0:
    return

  var castle = enemy_castles[0]
  for unit in commandable_units:
    unit.command.is_move = true
    unit.command.destination = castle.position


func _is_objective_pending(objective: Objective) -> bool:
  return objective.get_status() == Objective.Status.PENDING

func _is_castle(structure: Node) -> bool:
  return structure is Castle

func _is_enemy(structure: Node) -> bool:
  return structure.property.get_property("faction") * _faction == -1

func is_completed() -> bool:
  return _objectives.filter(_is_objective_pending).size() == 0

func deploy_units() -> void:
  while deployable_units.size() > 0:
    var unit = deployable_units[0]
    if unit.get_parent():
        unit.get_parent().remove_child(unit)
        
    if commandable_structures.size() == 0:
        unit.position = Vector2(0, 300)
    else:
        unit.position = commandable_structures[0].position + Vector2(50, 0)
        
    commandable_units.append(unit)
    _unit_manager.add_child(unit)
    deployable_units.remove_at(0)

func get_faction() -> int:
    return _faction
