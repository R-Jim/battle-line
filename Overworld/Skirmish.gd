extends Node2D

var squads: Dictionary[Squad, bool] = {}
var last_squads: Dictionary[Squad, bool]

@onready var skirmish_area = $Area2D

func _process(delta: float) -> void:
    #modify skirmish area base on squad distances:
    if squads.size() == 0:
        return
    
    var skirmish_position: Vector2
    for squad in squads:
        skirmish_position += squad.position
    
    position = skirmish_position/squads.size()
    if last_squads != squads:
        queue_redraw()
        last_squads = squads.duplicate()

func _draw() -> void:
    draw_circle(Vector2.ZERO, 100, Color.CHOCOLATE, false, 2, false)
