extends Node
class_name UnitManager

var registered_units: Dictionary[String, Unit] = {}  # Tracks units
var last_unit_index = 0

  
func _process(_delta: float) -> void:
    var childs = get_children()
    for child in childs:
        if child is Unit and not registered_units.has(child.id) and !child.is_removable:
            _register_unit(child, child.id)
    
    for unit_id in registered_units:
        if not registered_units[unit_id] or registered_units[unit_id].get_parent() != self:
            registered_units.erase(unit_id)


func _process_unit_skills(phase: StringName):
    for unit_id in registered_units:
        registered_units[unit_id].property.start_session()

    for unit_id in registered_units:
        for skill in registered_units[unit_id]._get_skills(phase):
            var targets = skill._get_targets()
            for target_id in targets:
                var property_updates = skill._get_target_effects(target_id)
                var target = targets[target_id]
                target.property.add_pending_update(property_updates)

            skill._notifi_source()
            skill._notifi_targets()
    return

func _process_unit_properties():
    for unit_id in registered_units:
        registered_units[unit_id].property.commit_pending_updates()
        registered_units[unit_id].property.commit_session()
    return


func _register_unit(unit: Node, unit_id: String):
    registered_units[unit_id] = unit
    last_unit_index+=1
    
    print("registered unit:", unit.id)

func _process_unit_removal():
    var tmp = registered_units.duplicate()
    for unit_id in tmp:
        var unit = registered_units[unit_id]
        if unit.is_removable:
            registered_units.erase(unit_id)
            remove_child(unit)


func _toggle_move_unit(toggle: bool):
    for unit_id in registered_units:
        registered_units[unit_id].property.set_property("is_move", toggle)

func get_units() -> Array[Unit]:
  return registered_units.values()


func add_unit(unit: Unit) -> void:
    if unit.get_parent():
        unit.get_parent().remove_child(unit)
        
    add_child(unit)
