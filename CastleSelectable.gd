extends Area2D

@export var sprite: Sprite2D
@export var caslte: Caslte

func _ready():
	self.mouse_entered.connect(_on_mouse_entered)
	self.mouse_exited.connect(_on_mouse_exited)

func _on_mouse_entered():
	sprite.modulate = Color(1, 1, 0.5)  # Yellow tint
	PlayerManager._hover(caslte)

func _on_mouse_exited():
	sprite.modulate = Color(1, 1, 1)  # Reset to normalo normal
	PlayerManager._dehover(caslte)
