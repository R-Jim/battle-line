extends Node

@export var player_squards: Array[Squad] = []

@export var _overworld_selectable_tile_map: SelectableTileMap

func _input(event):
    var current_mouse_position = get_viewport().get_mouse_position()

    if event is InputEventMouseButton:
        match event.button_index:
            MOUSE_BUTTON_RIGHT:
                if event.pressed:
                    if InputState.get_current_state() != &"SELECT_OWN_SQUAD":
                        return
                            
                    var input_data = InputState.get_current_state_data()
                    if input_data is not Squad:
                        return
                            
                    var squad: Squad = input_data
                    var destination = current_mouse_position
                    squad.command.is_move = true
                    squad.command.destination = destination
