extends Node2D
class_name SkirmishSelectableTileMap

var cell_size = Vector2(64, 64)  # Change to your grid size
var hovered_tile: Vector2i = Vector2i(-1, -1)

func _ready():
  PlayerManager._skirmish_selectable_tile_map_register(self)

func _process(_delta):
    var mouse_pos = get_local_mouse_position()
    var new_tile = Vector2i(mouse_pos / cell_size)

    if new_tile != hovered_tile:
        hovered_tile = new_tile
        queue_redraw()  # Only redraw when the hovered tile changes

#func _draw():
    #if hovered_tile.x >= 0 and hovered_tile.y >= 0:
        #var rect_pos = Vector2(hovered_tile) * cell_size
        #var rect = Rect2(rect_pos, cell_size)
        #draw_rect(rect, Color(1, 1, 0, 0.3))  # Filled
        #draw_rect(rect, Color(1, 1, 0), false, 2.0)  # Outline

func get_current_hovered_tile_center() -> Vector2:
  return Vector2(hovered_tile) * cell_size + cell_size/2 # to tile center
