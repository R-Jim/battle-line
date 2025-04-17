extends Skill

func _ready() -> void:
    _targets = {_source.id: _source}
    super._ready()

func _get_target_effects(_target_id: String) -> Dictionary:
    return {
        "resource": 1
    }
