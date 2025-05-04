extends Area2D
class_name Zone

var id = "corruption_zone_001"
@export var corruption_amount: int = 0
var _units: Dictionary[String, Unit] = {}  # Tracks unit properties

@onready var property: Property = $Property

func _ready() -> void:
    self.area_entered.connect(_on_area_entered)
    self.area_exited.connect(_on_area_exited)

func _on_area_entered(area: Area2D):
    if "source" not in area:
        return
    
    if area.source is not Unit:
        return

    _units[area.source.id] = area.source

func _on_area_exited(area: Area2D):
    if "source" not in area:
        return
    
    if area.source is not Unit:
        return

    _units.erase(area.source.id)

func get_units_corruption() -> int:
  var corruption = 0
  for unit in _units:
    var unit_corruption = _units[unit].property.get_property("corruption")
    if unit_corruption && unit_corruption is int:
      corruption += unit_corruption
  return corruption


func _get_skills(phase: StringName) -> Array[Skill]:
    var skills: Array[Skill] = []
    for child in get_children():
        if child is Skill and child._get_phase() == phase:
            skills.append(child)
    return skills
