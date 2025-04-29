extends Skill

var timer: Timer
@export var _sacrifice_unit_timer: int = 3

func _on_area_entered(area: Area2D):
    if "source" not in area:
        return
    
    if area.source == _source or area.source is Unit:
        _source.property.set_property("sacrifice_unit_timer", _sacrifice_unit_timer)

func _get_target_effects(_target_id: String) -> Dictionary:
    if _source.property.get_property("sacrifice_unit_timer") > 0:
      return {
        "sacrifice_unit_timer": - 1,
        "corruption": 5,
      }

    return {
      "health": - _source.property.get_property("health") * 100,
    }

func _get_targets() -> Dictionary:
    return {_source.id: _source}
