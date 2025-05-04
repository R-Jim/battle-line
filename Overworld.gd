extends Node2D

var skirmishs: Array[Skirmish] = []

func _draw() -> void:
    for child in get_children():
        if child is Region:
            for traversable in child.travserables:
                draw_dashed_line(child.position, traversable.position, Color.BLUE, 3.0, 5.0)
    
