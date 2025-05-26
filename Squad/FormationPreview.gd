extends Node2D

@export var squad: Node2D
@export var unit_rect_size: Vector2 = Vector2(8, 8)
@export var unit_color: Color = Color.BLUE
@export var border_color: Color = Color.RED
@export var border_width: float = 2.0

var formation: Formation

func _ready():
    if squad and squad.has_node("Formation"):
        formation = squad.get_node("Formation")

func _draw():
    if not formation:
        return
    
    # Draw unit rectangles
    var assignments = formation.formation_assignments
    for unit in assignments:
        var pos = assignments[unit]
        var rect = Rect2(pos - unit_rect_size * 0.5, unit_rect_size)
        draw_rect(rect, unit_color)
    
    # Draw formation border
    var border = formation.get_border()
    if border.size > Vector2.ZERO:
        draw_rect(border, border_color, false, border_width)
