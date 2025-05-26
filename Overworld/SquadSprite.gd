extends Sprite2D

var hovered_color = Color(1, 1, 0.5)  # Yellow tint
var selected_color = Color(0.5, 1, 0.5) # Green tint
var enemy_selected_color =  Color(1, 0.3, 0.3) # Red

func _ready() -> void:
    InputState.state_active.connect(_redraw_sprite)
    InputState.state_inactive.connect(_redraw_sprite)


func _draw() -> void:
    var color = Color(1, 1, 1)
    
    if InputState.get_current_state() == &"HOVER_SQUAD":
        color = hovered_color  
    if InputState.get_current_state() == &"SELECT_OWN_SQUAD":
        color = selected_color
        print(get_parent().name, " selected")
        
    if InputState.get_current_state() == &"SELECT_OTHER_SQUAD":
        color = enemy_selected_color
    
    modulate = color

func _redraw_sprite(state_name: String) -> void:
    if state_name != &"HOVER_SQUAD" and state_name != &"SELECT_OWN_SQUAD" and state_name != &"SELECT_OTHER_SQUAD":
        return
        
    if InputState.get_current_state_data() != get_parent():
        return
        
    queue_redraw()
