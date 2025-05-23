extends Node2D
class_name Base

@export var _faction: int
@export var _default_structure_strength: int = 5
@export var influence_strength = 3

func update_influence_strength(influence_tile_map: InfluenceTilemap) -> void:
    print(name, ", ", influence_tile_map.get_influence_at(position, true))
