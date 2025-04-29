extends Node
class_name Property

var _properties: Dictionary[StringName, PropertyStruct] = {}
var _pending_properties: Dictionary[StringName, PropertyStruct] = {}
var _pending_updates: Array[Dictionary] = []

func new_property(p: Dictionary[StringName, PropertyStruct]):
    _properties = p.duplicate()

func commit_pending_updates():
    for update in _pending_updates:
        for property in update:
            if _pending_properties.has(property):
                _pending_properties[property].add_value(update[property])
            else:
                _pending_properties[property] = PropertyStruct.new(update[property])
    _pending_updates = []

func get_property(property: StringName) -> Variant:
    if not _properties.has(property):
        return
    
    return _properties[property].get_current()

func get_pending_property(property: StringName) -> Variant:
    if not _pending_properties.has(property):
        return
    
    return _pending_properties[property].get_current()


func set_property(property: StringName, value: Variant):
    if _properties.has(property):
        _properties[property].set_value(value)
    else:
        _properties[property] = PropertyStruct.new(value)


func add_pending_update(property: Dictionary):
    _pending_updates.append(property)

func get_pending_updates() -> Array[Dictionary]:
    return _pending_updates.duplicate()


func start_section() -> void:
    _pending_properties = _properties.duplicate()


func commit_session() -> void:
    _properties = _pending_properties.duplicate()
