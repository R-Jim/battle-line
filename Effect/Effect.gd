extends Node
class_name Effect

@export var _property_name: String
@export var value_expression_string: String # exp: property["health"].get_current() + 5

var value_expression: Expression

var _removal_timer: Timer


func _ready() -> void:
    value_expression = Expression.new()
    var parse_result := value_expression.parse(value_expression_string, ["property"])
    
    if parse_result != OK:
        push_error("Failed to parse expression: %s" % value_expression_string)
            
    if has_node("RemovalTimer"):
        _removal_timer = $RemovalTimer
        _removal_timer.timeout.connect(on_remove)

func get_property_name() -> String:
    return _property_name


func get_value(properties):
    if not value_expression:
        return
    
    return value_expression.execute([properties], self)


func on_remove() -> void:
    if get_parent():
        get_parent().remove_child(self)
