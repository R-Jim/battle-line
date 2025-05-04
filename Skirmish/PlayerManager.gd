extends Node2D

var deploy_unit = preload("res://Units/footman.tscn")
var selected_units: Dictionary[Unit, bool]

@export var _unit_manager: UnitManager
@export var _structure_manager: StructureManager
var _skirmish_selectable_tile_map: SkirmishSelectableTileMap


func _input(event):
    var current_mouse_position = get_viewport().get_mouse_position()

    if event is InputEventMouseButton:
        match event.button_index:
            MOUSE_BUTTON_LEFT:
                if event.pressed:
                    for structure in _structure_manager.registered_structures.values():
                        if structure is Castle and structure.selectable.is_selected() and structure.property.get_property("faction") == 1:
                            var resource: int = structure.property.get_property("resource")
                            if resource >= 1:
                                var spawn = deploy_unit.instantiate()
                                spawn.id = "unit_00" + str(_unit_manager.last_unit_index + 1)
                                spawn.faction = 1
                                spawn.position = structure.position - Vector2(100, 0)
                                structure.property.set_property("resource", resource - 1)
                                _unit_manager.add_child(spawn)
                                _unit_manager._register_unit(spawn, spawn.id)
                                return

            MOUSE_BUTTON_RIGHT:
                if event.pressed:
                    var destination = _skirmish_selectable_tile_map.get_current_hovered_tile_center()
                    
                    for unit:Unit in _unit_manager.registered_units.values():
                        if unit.selectable.is_selected() and unit.property.get_property("faction") == 1:
                            unit.property.set_property("destination", destination)
                        


func _skirmish_selectable_tile_map_register(map: SkirmishSelectableTileMap) -> void:
  _skirmish_selectable_tile_map = map
