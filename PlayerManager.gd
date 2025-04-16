extends Node2D

var selected_nodes: Dictionary
var hover_node: Node2D
var is_multi_select := false
var deploy_unit = preload("res://unit.tscn")

var start_pos: Vector2
var end_pos: Vector2
var selecting := false
var selected_rect := Rect2()

func _hover(node: Node2D) -> void:
	if node and ((node is Unit and hover_node is Caslte) or hover_node == null):
		hover_node = node

func _dehover(node: Node2D) -> void:
	if hover_node == node:
		hover_node = null

func _input(event):
	is_multi_select = Input.is_key_pressed(KEY_SHIFT)

	if event is InputEventMouseButton:
		match event.button_index:
			MOUSE_BUTTON_LEFT:
				if event.pressed and hover_node is Unit:
					if is_multi_select:
						if selected_nodes.has(hover_node):
							selected_nodes.erase(hover_node)
						else:
							selected_nodes[hover_node] = true
					else:
						selected_nodes = {hover_node: true}
					return
				elif event.pressed and hover_node is Caslte and deploy_unit:
					var spawn = deploy_unit.instantiate()
					spawn.unit_id = "unit_00" + str(UnitManager.last_unit_index + 1)
					spawn.position = hover_node.position
					get_tree().root.add_child(spawn)
					return
			
				if event.pressed:
					start_pos = get_viewport().get_mouse_position()
					selecting = true
				elif selecting:
					end_pos = get_viewport().get_mouse_position()
					selecting = false
					selected_rect = Rect2(start_pos, end_pos - start_pos).abs()
					_select_units_in_rect(selected_rect)
					return

			MOUSE_BUTTON_RIGHT:
				if event.pressed and selected_nodes:
					var destination = get_viewport().get_mouse_position()
					for node in selected_nodes:
						if node:
							node.properties["destination"] = destination

func _process(delta):
	queue_redraw()

func _draw():
	if selecting:
		var rect = Rect2(start_pos, get_viewport().get_mouse_position() - start_pos).abs()
		draw_rect(rect, Color(0, 0.5, 1, 0.3), true)
		draw_rect(rect, Color(0, 0.5, 1), false)

func _select_units_in_rect(rect: Rect2):
	if !is_multi_select:
		selected_nodes.clear()
	
	for unit in UnitManager.registered_units.values():
		if rect.has_point(unit.global_position):
			selected_nodes[unit] = true
