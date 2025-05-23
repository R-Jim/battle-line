extends Node
class_name SquadEffect

@export var _property_name: String
@export var value_expression_string: String # exp: 10


var _unit_effects: Array[UnitEffect] = []
var value_expression: Expression

var _removal_timer: Timer


func _ready() -> void:
    value_expression = Expression.new()
    var parse_result := value_expression.parse(value_expression_string, [])
    
    if parse_result != OK:
        push_warning("Failed to parse expression: %s" % value_expression_string)
            
    if has_node("RemovalTimer"):
        _removal_timer = $RemovalTimer
        _removal_timer.timeout.connect(on_remove)
        
    for child in get_children():
        if child is UnitEffect:
            _unit_effects.append(child)

func get_property_name() -> String:
    return _property_name


func get_value():
    if not value_expression:
        return
    
    return value_expression.execute([], self)


func on_remove() -> void:
    if get_parent():
        get_parent().remove_child(self)

func get_unit_effects() -> Array[UnitEffect]:
    return _unit_effects.duplicate()
