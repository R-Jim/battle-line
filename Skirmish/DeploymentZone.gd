class_name DeploymentZone extends Area2D
@export var faction: int = 0
var is_occupied_flag: bool = false

func _ready():
  # Connect signals
  area_entered.connect(_on_area_entered)
  area_exited.connect(_on_area_exited)

func _on_area_entered(area):
  if area.get_parent() is Unit:
    is_occupied_flag = true

func _on_area_exited(area):
  if area.get_parent() is Unit:
    # Check if there are any other areas still overlapping
    if get_overlapping_areas().size() == 0:
      is_occupied_flag = false

func is_occupied() -> bool:
  return is_occupied_flag
