extends Node2D
class_name Base

@export var _faction: int
@export var _default_structure_strength: int = 5
@export var influence_strength = 3
const empty_structure_scene = preload("res://Structures/empty_structure.tscn")
const empty_structure_name = &"Empty"

func update_influence_strength(influence_tile_map: InfluenceTilemap) -> void:
    var incoming_influence_strength = influence_tile_map.get_influence_at(position, true)    
    if incoming_influence_strength == 0:
        return
    
    influence_strength += incoming_influence_strength
    if influence_strength > 0:
        _faction = 1
    elif influence_strength < 0:
        _faction = -1
    else :
        for child in get_children():
           remove_child(child)
        _faction = 0
        var empty_structure = empty_structure_scene.instantiate()
        empty_structure.name = empty_structure_name
        add_child(empty_structure)
        

func is_empty() -> bool:
    if get_child_count() == 0:
        return true
    
    var structure = get_child(0)
    if structure.name == empty_structure_name:
        return true
    
    return false
    

func build_structure(structure: PackedScene) -> void:
    if is_empty():
        for child in get_children():
           remove_child(child)
        
    add_child(structure.instantiate())
