extends Area2D
class_name Skill

@export var _range: int
@export var _action: String
@export var _source: Node
@export_enum(&"Strategic", &"Combat") var _phase: String
var _targets: Dictionary[String, Node] = {}  # Tracks unit properties
@onready var _hitbox = $CollisionShape2D

func _ready():
    if _range == 0:
        push_warning("Range not set")
    if _action == "":
        push_warning("Action not set")
    if _source == null:
        push_warning("Source not set")
    if _hitbox == null:
        push_warning("Hitbox not found")
    
    self.area_entered.connect(_on_area_entered)
    self.area_exited.connect(_on_area_exited)
    _hitbox["scale"] = Vector2(_range, _range)

func _on_area_entered(_area: Area2D):
    return

func _on_area_exited(_area: Area2D):
    return

func _get_targets() -> Dictionary:
    return _targets.duplicate()

func _get_target_effects(_target_id: String) -> Dictionary:
    push_warning("Child class should override _get_target_effects()")
    return {}
    
func _notifi_source():
    if _source == null || not _source.has_method("_receive_action_noti")  || _targets.size() == 0:
        return

    _source._receive_action_noti(_action, false)

func _notifi_targets():
    for target_id in _targets:
        if _targets[target_id].has_method("_receive_action_noti"):
            _targets[target_id]._receive_action_noti(_action, true)
            
func _get_phase() -> StringName:
    return _phase
