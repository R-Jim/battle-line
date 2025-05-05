extends Node

@export var player_squards: Array[Squad] = []

var _overworld_selectable_tile_map: SelectableTileMap

func _input(event):
    var current_mouse_position = get_viewport().get_mouse_position()

    if event is InputEventMouseButton:
        match event.button_index:
            MOUSE_BUTTON_RIGHT:
                if event.pressed:
                    var destination = _overworld_selectable_tile_map.get_current_hovered_tile_center()
                    
                    for squad:Squad in player_squards:
                        if squad.selectable.is_selected():
                            squad.command.is_move = true
                            squad.command.destination = destination


func _selectable_tile_map_register(map: SelectableTileMap) -> void:
  _overworld_selectable_tile_map = map
