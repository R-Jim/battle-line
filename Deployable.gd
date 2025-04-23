extends Node

@export var _deployable_units: Array[Unit]

func _ready():
  var childs = get_children()
  for child in childs:
    child.position = Vector2i(-1000, -1000)
    child.set_visible(false)
    child.set_process(false)
    child.set_physics_process(false)

func get_deployable() -> Array[Unit]:
  return _deployable_units.duplicate()
