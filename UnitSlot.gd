extends Panel

var _unit: Unit

@onready var _unit_sprite = $UnitSprite
@onready var _unit_health_bar = $HealthBar

func set_unit(unit: Unit):
    _unit = unit

func _process(_delta: float) -> void:
    if not _unit:
        _unit_health_bar.visible = false
        _unit_sprite.texture = null
        _unit_sprite.hframes = 1
        _unit_sprite.vframes = 1
        return

    _unit_health_bar.visible = true
    _unit_health_bar.value = float(_unit.property.get_property("health")) / _unit.max_health * 100
    
    var source_sprite = _unit.sprite
    _unit_sprite.texture = source_sprite.texture
    _unit_sprite.hframes = source_sprite.hframes
    _unit_sprite.vframes = source_sprite.vframes
    
