extends Node2D

var squads: Array[Squad] = []
var last_position: Vector2

@onready var skirmish_area = $Area2D

func _process(delta: float) -> void:
    #modify skirmish area base on squad distances:
    if squads.size() == 0:
        return
    
    var skirmish_position: Vector2
    for squad in squads:
        skirmish_position += squad.position
    
    position = skirmish_position/squads.size()
    if last_position != position:
        queue_redraw()
        last_position = position

func _draw() -> void:
    draw_circle(Vector2.ZERO, 100, Color.CHOCOLATE, false, 2, false)
