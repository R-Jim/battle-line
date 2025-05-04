extends StaticBody2D
class_name Castle

@export var id: String = "caslte_000"
@export var max_health: int = 500
@export var max_resource: int = 1
@export var faction = 1
@onready var property: Property = $Property

@onready var health_bar = $HealthBar
@onready var selectable = $Selectable

func _ready():
    property.new_property({
        "health": PropertyStruct.new(max_health, max_health),
        "faction": PropertyStruct.new(faction),
        "resource": PropertyStruct.new(max_resource, max_resource),
    })
    update_health_bar()

func _process(_delta: float) -> void:
    update_health_bar()
    
func _remove():
    queue_free()

func update_health_bar():
    if health_bar:
        health_bar.value = float(property.get_property("health")) / max_health * 100

func _get_skills(phase: StringName) -> Array[Skill]:
    var skills:Array[Skill] = []
    for child in get_children():
        if child is Skill and child._get_phase() == phase:
            skills.append(child)
    return skills
