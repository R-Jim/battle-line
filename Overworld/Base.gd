extends Node2D
class_name Base

@export var _faction: int
@export var _default_structure_strength: int = 5
@export var influence_strength = 3

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
        _faction = 0
