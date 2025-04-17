extends Node

var registered_structures: Dictionary[String, Castle] = {}  

func _process_structure_skills(phase: StringName):
    for structure_id in registered_structures:
        for skill in registered_structures[structure_id]._get_skills(phase):
            var targets = skill._get_targets()
            for target_id in targets:
                var property_updates = skill._get_target_effects(target_id)
                var target = targets[target_id]
                if target is Castle:
                    target.property.add_pending_property(property_updates)
                    
            skill._notifi_source()
            skill._notifi_targets()
    
func _register(structure: Castle, id: String):
    registered_structures[id] = structure

func _process_structures_health():
    for id in registered_structures:
        if registered_structures[id].property.get_property("health") <= 0:
            var structure = registered_structures[id]
            registered_structures.erase(id)
            structure._remove()

func _process_structure_properties():
    for id in registered_structures:
        registered_structures[id].property.commit_pending_properties()
    return
