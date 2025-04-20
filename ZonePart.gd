extends Area2D
class_name ZonePart

var _corruption: int

func _ready():
    self.area_entered.connect(_on_zone_entered)

func _on_zone_entered(unit: Unit):
  if unit:
    unit._register_zone(self)
    return
