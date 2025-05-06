extends Node
class_name Skirmish

@onready var _selectable_tilemap = $SelectableTileMap
@onready var _unit_manager = $CycleManager/UnitManager
@onready var _structure_manger = $CycleManager/StructureManager

func commander_register(_commander: Commander):
    print("commander joined")

func squad_join(_squad: Squad):
    print("squad joined")
