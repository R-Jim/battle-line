extends Node
class_name OverworldUnitBuff

@export var property_name: String
@export var value_expression_string: String # exp: property["health"].get_current() + 5
@export var squad: Squad

var value_expression: Expression

var activation_timer: Timer
var removal_timer: Timer


func _ready() -> void:
    value_expression = Expression.new()
    var parse_result := value_expression.parse(value_expression_string, ["property"])
    
    if parse_result != OK:
        push_error("Failed to parse expression: %s" % value_expression_string)
        
    if has_node("ActivationTimer"):
        activation_timer = $ActivationTimer
        activation_timer.timeout.connect(on_active)
    else:
        on_active()
    
            
    if has_node("RemovalTimer"):
        removal_timer = $RemovalTimer
        removal_timer.timeout.connect(on_remove)

    
func on_active() -> void:
    if not value_expression:
        return
    
    for unit in squad.units:
        var properties = unit.property.get_current_properties()
        var property: PropertyStruct = properties[property_name]
        
        var value = value_expression.execute([properties], self)
        
        value = property.get_current() + value
        var max = property.get_max()
        if max and value > max:
            value = max

        unit.property.set_property(property_name, value)

func on_remove() -> void:
    queue_free()
