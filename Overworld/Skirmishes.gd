extends Node2D

@export var squards_manager: Node2D
const skirmish_scene = preload("res://Skirmish/skirmish.tscn")

var skirmishes: Dictionary[Array, Skirmish] = {} # Array[Squad]
var _squard_skirmishes: Dictionary[Squad, Skirmish] = {}

func _process(delta: float) -> void:
    var squards: Array[Squad] = []
    for child in squards_manager.get_children():
        if child is Squad:
            squards.append(child)
    
    for squad in squards:
        if not squad.in_skirmish:
            continue
        
        var skirmish: Skirmish
        if not _squard_skirmishes.has(squad):
            skirmish = skirmish_scene.instantiate()
            add_child(skirmish)
            skirmish.squad_join(squad)
            _squard_skirmishes[squad] = skirmish
        else:
            skirmish = _squard_skirmishes[squad]
        
        for engaged_squad in squad.nearby_squads:
            if not _squard_skirmishes.has(engaged_squad):
                skirmish.squad_join(engaged_squad)
                _squard_skirmishes[engaged_squad] = skirmish
