extends Node

var pending_updates = {}

func _append_property_update(update: Dictionary, target_id: String):
	if not pending_updates.has(target_id):
		pending_updates[target_id] = []
	pending_updates[target_id].append(update)

func _retrieve_pending_properties() -> Dictionary:
	var	result = pending_updates.duplicate(true)
	pending_updates = {}
	return result  # Returns a copy to prevent modification
