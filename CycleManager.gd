extends Node

@export var strategic_cycle_time: float = 5.0  # Cycle duration in seconds
@export var combat_cycle_time: float = 5.0  # Cycle duration in seconds

@onready var strategic_timer: Timer = _strategic_timer()
@onready var combat_timer: Timer = _combat_timer()
var phases = [&"Strategic", &"Combat"]
var currentPhaseIndex = -1

func _process(_delta: float) -> void:
    if currentPhaseIndex == -1:
        print("start strategic")
        _strategic_start_cycle()
        strategic_timer.start()	
        currentPhaseIndex = 0
        return
        
    if currentPhaseIndex == 1:
        if combat_timer.is_stopped():
            print("start combat")
            combat_timer.start()
        return
    
    
func _strategic_timer() -> Timer:
    var timer = Timer.new()
    timer.wait_time = strategic_cycle_time
    timer.one_shot = true
    timer.timeout.connect(_strategic_end_cycle)
    add_child(timer)
    return timer

func _combat_timer() -> Timer:
    var timer = Timer.new()
    timer.wait_time = combat_cycle_time
    timer.one_shot = true
    timer.timeout.connect(_combat_end_cycle)
    add_child(timer)
    return timer
    
func _strategic_start_cycle():
    UnitManager._toggle_move_unit(true)

func _strategic_end_cycle():
    UnitManager._toggle_move_unit(false)
    currentPhaseIndex = 1 # transition to combat phase

func _combat_end_cycle():
    UnitManager._process_unit_skills(&"Combat")
    StructureManager._process_structure_skills(&"Combat")
    UnitManager._process_unit_properties()
    StructureManager._process_structure_properties()
    UnitManager._process_unit_health()
    StructureManager._process_structures_health()
    currentPhaseIndex = -1 # transition to start of strategic phase
