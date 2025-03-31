extends Node

var registered_units = {}  # Tracks unit properties

func _register_unit(unit_id: String, properties: Dictionary):
	registered_units[unit_id] = properties

func _append_properties(properties: Dictionary):
	for unit_id in properties:
		var existing_value = registered_units.get(unit_id, {})
		
		if existing_value is not Dictionary:
			push_error("append_properties: Existing value for unit '" + unit_id + "' is not a Dictionary")

		for update in properties[unit_id]:
			for property in update:
				if existing_value.has(property):
					if existing_value[property] is int or existing_value[property] is float:
						existing_value[property] += update[property]
					else:
						push_error("append_properties: Cannot modify non-numeric property: " + property)
				else:
					push_error("append_properties: Property does not exist in registered_units: " + property)

	print("Base Properties After Update:", registered_units)

func _get_property(unit_id):
	return registered_units[unit_id]
	
