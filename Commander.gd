extends Node
class_name Commander

@export var _faction: int
@export_enum(&"capture", &"attack") var _objective_types: Array[String] = []
var _objectives: Array[Objective] = []

@export var commander_points: int
@export var commandable_units: Array[Unit] = []

func _ready() -> void:
  for objective_type in _objective_types:
    var objective = Objective.new()
    objective.set_type(objective_type)
    _objectives.append(objective)

func _process(_delta):
  var pending_objectives = _objectives.filter(_is_objective_pending)
  
  for objective in pending_objectives:
      _process_objective(objective)

func _process_objective(objective: Objective) -> void:
  if objective.get_type() == "capture":
    if StructureManager.registered_structures.values().filter(_is_castle).size() > 0 and StructureManager.registered_structures.values().filter(_is_castle_enemy).size() == 0:
      objective.mark_complete()
  return

func command_units() -> void:
  var pending_objectives = _objectives.filter(_is_objective_pending)
  if pending_objectives.size() == 0:
    return

  var objective = pending_objectives[0]
  if objective.get_type() == "capture":
    _command_units_capture()
  
func _command_units_capture() -> void:
  var enemy_castles = StructureManager.registered_structures.values().filter(_is_castle_enemy)
  if enemy_castles.size() == 0:
    return

  var castle = enemy_castles[0]
  for unit in commandable_units:
    unit.property.set_property("destination", castle.position)


func _is_objective_pending(objective: Objective) -> bool:
  return objective.get_status() == Objective.Status.PENDING

func _is_castle(structure: Node) -> bool:
  return structure is Castle

func _is_castle_enemy(structure: Node) -> bool:
  return structure is Castle && structure.property.get_property("faction") * _faction == -1
