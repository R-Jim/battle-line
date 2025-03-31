extends Node

# The currently selected unit (could be a custom Unit class extending Node2D or similar)
var selected_node: Node2D
var hover_node: Node2D

var deploy_unit = preload("res://unit.tscn")

# set unit destination

func _hover(node: Node2D) -> void:
	if !node:
		return
	
	if (node is Unit and hover_node is Caslte) or hover_node == null:
		hover_node = node
		
func _dehover(node: Node2D) -> void:
	if hover_node == node:
		hover_node = null
		

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
		if selected_node:
			var destination = get_viewport().get_mouse_position()
			selected_node.properties["destination"] = destination
	
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		if hover_node is Unit:
			print("select unit")
			selected_node=hover_node
		elif hover_node is Caslte and deploy_unit != null:
			print("select castle")
			var 	spawn = deploy_unit.instantiate()
			spawn.unit_id = "unit_00" + str(UnitManager.registered_units.size()+1)
			spawn.position = hover_node.position
			get_tree().root.add_child(spawn)
		else:
			selected_node=null
