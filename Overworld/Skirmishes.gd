extends Node2D

@export var squards_manager: Node2D
const skirmish_scene = preload("res://Skirmish/skirmish.tscn")

var _squard_skirmishes: Dictionary[Squad, Skirmish] = {}
var _skirmishes: Array[Skirmish] = []

func _process(delta: float) -> void:
    var squards: Array[Squad] = []
    for child in squards_manager.get_children():
        if child is Squad:
            squards.append(child)
    
    for squad in squards:
        if not squad.in_skirmish or not squad.is_skirmish_ready:
            continue
        
        var engaged_squad_in_skirmish_count = 0
        for engaged_squad: Squad in squad.nearby_squads:
            if engaged_squad.is_skirmish_ready:
                engaged_squad_in_skirmish_count += 1
            
        if engaged_squad_in_skirmish_count == 0:
            if not squad.is_skirmish_ready or engaged_squad_in_skirmish_count == 0 and _squard_skirmishes.has(squad):
                _squard_skirmishes[squad].squad_return(squad)
                _squard_skirmishes.erase(squad)
                print("squad[", squad.name, "] returns from skirmish")
            continue

        var skirmish: Skirmish
        if not _squard_skirmishes.has(squad):
            skirmish = skirmish_scene.instantiate()
            add_child(skirmish)
            _skirmishes.append(skirmish)
            skirmish.squad_join(squad)
            _squard_skirmishes[squad] = skirmish
        else:
            skirmish = _squard_skirmishes[squad]
            
        for engaged_squad: Squad in squad.nearby_squads:
            if not _squard_skirmishes.has(engaged_squad) and engaged_squad.is_skirmish_ready:
                skirmish.squad_join(engaged_squad)
                _squard_skirmishes[engaged_squad] = skirmish

    
    for skirmish:Skirmish in _skirmishes:     
        if skirmish and skirmish.is_skirmish_complete():
            skirmish.queue_free()
