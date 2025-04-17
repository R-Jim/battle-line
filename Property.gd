extends Node
class_name Property

var _properties: Dictionary = {}
var _pending_properties: Array[Dictionary] = []

func new_property(p: Dictionary):
    _properties = p.duplicate()

func commit_pending_properties():
    for update in _pending_properties:
        for property in update:
            if _properties.has(property):
                if _properties[property] is int or _properties[property] is float:
                    _properties[property] += update[property]
                else:
                    push_error("append_properties: Cannot modify non-numeric property: " + property)
            else:
                push_error("append_properties: Property does not exist in: " + property)
    _pending_properties = []

func get_property(property: StringName) -> Variant:
    if not _properties.has(property):
        return
    
    return _properties[property]

func set_property(property: StringName, value: Variant):
    _properties[property] = value


func add_pending_property(property: Dictionary):
    _pending_properties.append(property)
