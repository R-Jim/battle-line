extends Skill

func _on_area_entered(area: Area2D):
    if "source" not in area:
        return
    
    if area.source == _source or area.source is not Unit:
        return

    if _source.property.get_property("faction") * area.source.property.get_property("faction") < 0:
        _targets[area.source.id] = area.source

func _on_area_exited(area: Area2D):
    if "source" not in area or area.source is not Unit and area.source is not Castle:
        return

    _targets.erase(area.source.id)

func _get_target_effects(_target_id: String) -> Dictionary:
    return {
            "health": -_source.property.get_property("attack")
    }
