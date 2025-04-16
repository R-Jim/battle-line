extends Node

var registered_units = {}  # Tracks units
var last_unit_index = 0

func _process_unit_skills(phase: String):
	for unit_id in registered_units:
		for skill in registered_units[unit_id]._get_skills(phase):
			var property_updates = skill._get_target_effects()
			for target_unit_id in property_updates:
				PendingProperty._append_property_update(property_updates[target_unit_id], target_unit_id)

			skill._notifi_units()
	return

func _register_unit(unit: Node, unit_id: String, properties: Dictionary):
	registered_units[unit_id] = unit
	BaseProperty._register_unit(unit_id, properties)
	last_unit_index+=1
	
	unit._confirm_registration()  # Call back to confirm
	#print("Registered Units After Update:", registered_units)

func _process_unit_health():
	for unit_id in registered_units:
		if registered_units[unit_id].properties["health"] <= 0:
			var unit = registered_units[unit_id]
			registered_units.erase(unit_id)
			unit._remove()


func _toggle_move_unit(toggle: bool):
	for unit_id in registered_units:
		registered_units[unit_id].properties["is_move"] = toggle
