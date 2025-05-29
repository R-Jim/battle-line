extends Node
class_name UnitManager

signal other_unit_processed(unit_manager, unit, output)

var registered_units: Array[Unit] = []

func _ready():
    # Register existing children
    for child in get_children():
        if child is Unit:
            register_unit(child)

    # Use connect() instead of deprecated signal syntax
    child_entered_tree.connect(_on_child_entered)
    child_exiting_tree.connect(_on_child_exiting)

func register_unit(unit: Unit) -> void:
    if registered_units.has(unit):
        return
    registered_units.append(unit)
    other_unit_processed.connect(unit._process_other_unit_skills)

func unregister_unit(unit: Unit) -> void:
    registered_units.erase(unit)

func _on_child_entered(child: Node) -> void:
    if child is Unit:
        register_unit(child)

func _on_child_exiting(child: Node) -> void:
    if child is Unit and child.is_removable:
        unregister_unit(child)
        
func _process(delta: float) -> void:
    for unit in registered_units.duplicate():
        if unit.is_removable:
            unregister_unit(unit)

func process_all_units(phase: StringName) -> void:
    for unit: Unit in registered_units:
        var skills = unit.get_skills(phase)
        
        var interactions: Array = []
        for skill: Skill in skills.values():
            skill.process_targets(registered_units.duplicate())
            
            var target_interactions = skill.get_target_interactions()
            for target_unit: Unit in target_interactions:
                for interaction in target_interactions[target_unit]:
                    target_unit.property.add_pending_update(interaction)
                target_unit.property.commit_pending_updates()
            interactions.append(target_interactions)
        
        other_unit_processed.emit(self, unit, interactions)
