extends Node2D

@export var squards_manager: Node2D
@export var skirmish_map_container: Node2D
@export var skirmish_map_viewer: SubViewport
const skirmish_map_scene = preload("res://Skirmish/skirmish.tscn")
const skirmish_scene = preload("res://Overworld/skirmish.tscn")

var _squard_skirmishes: Dictionary[Squad, Skirmish] = {}
var _skirmishes: Array[Skirmish] = []
var _skirmish_to_zone: Dictionary[Skirmish, Node2D] = {}

func _process(_delta: float) -> void:
    var squards: Array[Squad] = []
    for child in squards_manager.get_children():
        if child is Squad:
            squards.append(child)

    
    for squad in squards:
        var is_squad_engaged = squad.is_skirmish_ready and squad.nearby_hostile_squads.filter(func(hostile_squad: Squad): return hostile_squad.is_skirmish_ready).size() > 0
        if squad.in_skirmish and not is_squad_engaged:
            squad_leave_skirmish(squad)
            print("squad[", squad.name, "] returns from skirmish")
            continue
        elif not is_squad_engaged:
            continue

        var skirmish: Skirmish
        if not _squard_skirmishes.has(squad):
            skirmish = skirmish_map_scene.instantiate()
            skirmish_map_viewer.add_child(skirmish)
            _skirmishes.append(skirmish)
            
            var skirmish_zone = skirmish_scene.instantiate()
            add_child(skirmish_zone)
            _skirmish_to_zone[skirmish] = skirmish_zone
            squad_join_skirmish(squad, skirmish)
        else:
            skirmish = _squard_skirmishes[squad]
            
        for engaged_squad: Squad in squad.nearby_hostile_squads:
            if not _squard_skirmishes.has(engaged_squad) and engaged_squad.is_skirmish_ready:
                squad_join_skirmish(engaged_squad, skirmish)

    
    for skirmish:Skirmish in _skirmishes:     
        if skirmish and skirmish.is_skirmish_complete():
            var skirmish_zone = _skirmish_to_zone[skirmish]
            _skirmish_to_zone.erase(skirmish)
            skirmish.free()
            skirmish_zone.free()

func squad_join_skirmish(squad: Squad, skirmish: Skirmish):
    skirmish.squad_join(squad)
    _squard_skirmishes[squad] = skirmish
    _skirmish_to_zone[skirmish].squads[squad] = true

func squad_leave_skirmish(squad):
    var skirmish = _squard_skirmishes[squad]
    skirmish.squad_return(squad)
    _squard_skirmishes.erase(squad)
    _skirmish_to_zone[skirmish].squads.erase(squad)   
