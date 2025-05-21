extends Node2D

@onready var squads = $Squads
var overworld_timer: Timer

func _ready() -> void:
    overworld_timer = Timer.new()
    overworld_timer.wait_time = 5
    overworld_timer.autostart = true
    overworld_timer.timeout.connect(overworld_cronjob)
    add_child(overworld_timer)

func _draw() -> void:
 pass

func overworld_cronjob() -> void:
    for squad:Squad in squads.get_children():
        if squad.in_skirmish:
            continue
        squad.reset_movement()
        for unit: Unit in squad.get_units():
            unit.property.start_session()
            unit.property.commit_session()
