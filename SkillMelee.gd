extends Area2D

@export var unit: Unit
@export var action = "attack"

var target_units = {}  # Tracks unit properties

func _ready():
	self.area_entered.connect(_on_area_entered)
	self.area_exited.connect(_on_area_exited)

func _on_area_entered(area: Area2D):
	if "unit" not in area:
		return

	if area.unit != unit and unit.properties["faction"] * area.unit.properties["faction"] < 0:
		target_units[area.unit.unit_id] = area.unit

func _on_area_exited(area: Area2D):
	if "unit" not in area or "unit_id" not in area.unit:
		return

	target_units.erase(area.unit.unit_id)

func _get_targets() -> Dictionary:
	return target_units.duplicate()

func _get_target_effects() -> Dictionary:
	var target_unit_effects = target_units.duplicate()
	
	for target_unit_id in target_unit_effects:
		target_unit_effects[target_unit_id] = {
			"health": -unit.properties["attack"]
		}
	
	return target_unit_effects
	
func _notifi_units():
	if target_units == {}:
		return
	
	unit._receive_action_noti(action, false)
	
	for target_unit_id in target_units:
		target_units[target_unit_id]._receive_action_noti(action, true)
