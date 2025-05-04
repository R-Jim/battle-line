extends Area2D

@export var sprite: Sprite2D
@export var source: Node2D

var _is_hovered: bool = false
var _is_selected: bool = false

func _ready():
    self.mouse_entered.connect(_on_mouse_entered)
    self.mouse_exited.connect(_on_mouse_exited)
    
func _process(_delta: float) -> void:
    _is_hovered = Player.grouped_rect.has_point(source.position)
    
    sprite.modulate = Color(1, 1, 1)
    if _is_hovered:
        sprite.modulate = Color(1, 1, 0.5)  # Yellow tint
    
    if _is_selected:
        sprite.modulate = Color(0.5, 1, 0.5)  # Green tint
        

func _input(event: InputEvent) -> void:
    if event is InputEventMouseButton:
        match event.button_index:
            MOUSE_BUTTON_LEFT:
                if _is_hovered:
                    _is_selected = true
                if _is_selected and not _is_hovered and not Player.is_multiple_units_select_mode:
                    _is_selected = false


func _on_mouse_entered():
    _is_hovered = true


func _on_mouse_exited():
    _is_hovered = false

func is_hovered() -> bool:
    return _is_hovered

func is_selected() -> bool:
    return _is_selected

#func set_selected(value: bool) -> void:
    #_is_selected = value
#
#func set_hovered(value: bool) -> void:
    #_is_hovered = value
