extends Node2D

@export var faction: int = 0
@export var squards: Array[Squad] = []
@export var buildable_structures: Array[PackedScene] = []
@export var bases: Node2D

func _process(_delta: float) -> void:
    squards = squards.filter(func(squad: Squad): return squad.get_parent())
