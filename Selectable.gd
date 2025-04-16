extends Area2D

@export var sprite: Sprite2D
@export var unit: Unit

func _ready():
	self.mouse_entered.connect(_on_mouse_entered)
	self.mouse_exited.connect(_on_mouse_exited)
	
func _process(delta: float) -> void:
	if PlayerManager.selected_nodes.has(unit):
		sprite.modulate = Color(0.5, 1, 0.5)  # Green tint
	elif PlayerManager.hover_node is Unit and PlayerManager.hover_node.unit_id == unit.unit_id:
		sprite.modulate = Color(1, 1, 0.5)  # Yellow tint
	else:
		sprite.modulate = Color(1, 1, 1)

func _on_mouse_entered():
	PlayerManager._hover(unit)

func _on_mouse_exited():
	PlayerManager._dehover(unit)
