extends Node2D

var is_multiple_units_select_mode: bool
var is_group_units_select_mode: bool

var mouse_start_pos: Vector2
var mouse_end_pos: Vector2

var grouped_rect: Rect2


func _input(event):
    var current_mouse_position = get_viewport().get_mouse_position()
    
    if event is InputEventMouseButton:
        match event.button_index:
            MOUSE_BUTTON_LEFT:          
                if event.pressed:
                    mouse_start_pos = current_mouse_position
                    is_group_units_select_mode = true
                elif is_group_units_select_mode:
                    is_group_units_select_mode = false
    
    if is_group_units_select_mode:
        grouped_rect = Rect2(mouse_start_pos - Vector2(20, 20), current_mouse_position - mouse_start_pos + Vector2(40, 40)).abs()
        queue_redraw()
    else:
        grouped_rect = Rect2(current_mouse_position - Vector2(20, 20),  Vector2(40, 40)).abs()
        queue_redraw()
        
    is_multiple_units_select_mode = Input.is_key_pressed(KEY_SHIFT)



func _draw():
    draw_rect(grouped_rect, Color(0, 0.5, 1, 0.3), true)
    draw_rect(grouped_rect, Color(0, 0.5, 1), false)
