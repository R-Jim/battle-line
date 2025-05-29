extends CharacterBody2D
class_name Unit

@export var max_health = 100
@export var strength = 10
@export var faction = 1
@export var in_formation = true

@onready var property: Property = $Property

@onready var health_bar = $HealthBar
@onready var sprite = $Sprite2D

@onready var animation_player = $AnimationPlayer
@onready var animation_tree = $AnimationTree
@onready var state_machine = animation_tree["parameters/playback"]

var is_removing: bool
var is_removable: bool

func _ready():
    property.new_property({
        "health": PropertyStruct.new(max_health, max_health),
        "strength": PropertyStruct.new(strength),
        "faction": PropertyStruct.new(faction),
        "in_melee": PropertyStruct.new(false),
        "in_formation": PropertyStruct.new(in_formation),
    })
    
    if property.get_property("faction") > 0:
        sprite["flip_h"] = true
    

func _process(_delta: float) -> void:
    update_health_bar()
    queue_redraw()
 
    if is_removing and state_machine.get_current_node() == "End":
        is_removable = true
        
    if property.get_property("health") <= 0 and not is_removing:
        is_removing = true
        state_machine.travel("die")

func _receive_action_noti(action: String, _isTarget: bool):
    state_machine.travel(action)

func update_health_bar():
    if health_bar:
        health_bar.value = float(property.get_property("health")) / max_health * 100

func _notification(what):
    if what == NOTIFICATION_PARENTED:
        if state_machine:
            state_machine.travel("Start")        
        is_removing = false
        is_removable = false

func _process_other_unit_skills(unit: Unit, output) -> void:
    print(name, " processed:", unit.name, output)

func get_skills(phase: StringName):
    var skills: Dictionary[String, Skill] = {}
    for child in get_children():
        if child is not Skill:
            continue
        
        var skill_phase = child._active_phase
        if skill_phase == phase:
            skills[child.skill_id] = child
    
    return skills
    
