extends Node

const input_state_machine = {
    _default_state: {
        &"SELECT_OWN_SQUAD": {
            &"COMMAND_MOVE": {}
        },
        &"SELECT_OTHER_SQUAD": {
        },
    }
}

const _default_state = &"IDLE"
var _current_travers = []
var _current_input_data: Variant

signal state_active(state_name: String)
signal state_inactive(state_name: String)

func _ready() -> void:
    reset_state()

func traverse_state(state: StringName, input_data: Variant = null) -> bool:
    var current_state_object = input_state_machine
    var remaining_state_traverse = _current_travers.duplicate()
    var last_state: StringName
    for remaining_state in remaining_state_traverse:
        current_state_object = current_state_object[remaining_state]
        last_state = remaining_state
      
    
    if current_state_object.has(state):
        _current_travers.append(state)
        _current_input_data = input_data
        _emit_state_nodes(last_state, false)
        _emit_state_nodes(state, true)
        return true
    else:
        return false

func get_current_state() -> StringName:
    if _current_travers.size() == 0:
        return _default_state
    
    return _current_travers[_current_travers.size()-1]
    
func get_current_state_data() -> Variant:
    return _current_input_data

func reset_state() -> void: 
    _emit_state_nodes(get_current_state(), false)    
    _current_travers = [_default_state]
    _current_input_data = null
    print("reset")


func _emit_state_nodes(state: StringName, is_active: bool = false) -> void:
    if is_active:
        emit_signal("state_active", state)
    else:
        emit_signal("state_inactive", state)
