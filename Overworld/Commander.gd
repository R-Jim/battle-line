extends Node

@export var targets_steps: Array[Array] = []
var center_y = 450
var assign_squad_target_timer: Timer

func _ready() -> void:
    var i: int
    for targets in targets_steps:
        targets.sort_custom(sort_right_center)
        targets_steps[i] = targets
        
    assign_squad_target_timer = Timer.new()
    assign_squad_target_timer.wait_time = 1
    assign_squad_target_timer.timeout.connect(assign_squad_target)
    assign_squad_target_timer.autostart = true
    add_child(assign_squad_target_timer)
        

func sort_right_center(a, b):
    if a is NodePath:
        a = get_node(a)
    if b is NodePath:
        b = get_node(b)
    
    # First, sort by X descending (right to left)
    if a.position.x != b.position.x:
        return b.position.x < a.position.x
    
    # Then, sort by distance from center_y
    var dist_a = abs(a.position.y - center_y)
    var dist_b = abs(b.position.y - center_y)
    return dist_b > dist_a
        

func assign_squad_target() -> void:
    var squads = get_parent().squards.duplicate()
    squads.sort_custom(sort_right_center)

    var is_step_completed: bool
    var step_number: int = 0
    for targets in targets_steps:
        step_number += 1
        is_step_completed = true
        for target_node_path in targets:
            var target_base: Base = get_node(target_node_path)
            if target_base._faction != -1:
                is_step_completed = false
                var squad = squads.pop_front()
                if not squad:
                    break

                squad.command.is_move = true
                squad.command.destination = target_base.position
            
        if is_step_completed:
            if step_number == targets_steps.size():
                print("all targets completed")
            return
