extends Area2D

@export var source: Node2D

func _input_event(viewport, event, shape_idx) -> void:
    if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
        if InputState.get_current_state() == &"IDLE":
            _select()

func _unhandled_input(event: InputEvent) -> void:
    if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
        if _should_deselect():
            InputState.reset_state()

func _select() -> void:
    var parent = get_parent()
    var state = &"SELECT_OTHER_SQUAD"
    if parent.get_faction() == 1:
        state = &"SELECT_OWN_SQUAD"
    InputState.traverse_state(state, parent)

func _should_deselect() -> bool:
    return InputState.get_current_state() in [&"SELECT_OWN_SQUAD", &"SELECT_OTHER_SQUAD"]
