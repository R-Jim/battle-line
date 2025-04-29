class_name PropertyStruct

var _current: Variant
var _max: Variant

func _init(current: Variant, max_value: Variant = null):
    self._current = current
    self._max = max_value

func get_current() -> Variant:
  return _current

func get_max() -> Variant:
  return _max

func add_value(value: Variant):
  if typeof(value) != typeof(_current):
    push_error("PropertyStruct: Cannot add value of different type")
    return

  _current += value
  if _max and _current > _max:
    _current = _max

func set_value(value: Variant):
  if typeof(value) != typeof(_current):
    push_error("PropertyStruct: Cannot set value of different type")
    return

  _current = value
