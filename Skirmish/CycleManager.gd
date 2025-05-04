extends Node

@export var strategic_cycle_time: float = 1.0  # Cycle duration in seconds
@export var combat_cycle_time: float = 1.0  # Cycle duration in seconds

@onready var strategic_timer: Timer = _strategic_timer()
@onready var combat_timer: Timer = _combat_timer()

@onready var _unit_manager: UnitManager = $UnitManager
@onready var _structure_manager: StructureManager = $StructureManager


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
    _unit_manager._toggle_move_unit(true)

func _strategic_end_cycle():
    _unit_manager._toggle_move_unit(false)
    _unit_manager._process_unit_skills(phases[currentPhaseIndex])
    _structure_manager._process_structure_skills(phases[currentPhaseIndex])
    currentPhaseIndex = 1 # transition to combat phase

func _combat_end_cycle():
    _unit_manager._process_unit_skills(phases[currentPhaseIndex])
    _structure_manager._process_structure_skills(phases[currentPhaseIndex])
    _unit_manager._process_unit_properties()
    _structure_manager._process_structure_properties()
    _unit_manager._process_unit_health()
    _structure_manager._process_structures_health()
    currentPhaseIndex = -1 # transition to start of strategic phase
