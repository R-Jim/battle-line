extends Node
class_name Objective

@export_enum(&"capture", &"attack")
var _type

enum Status {
    PENDING,
    SUCCESS,
    FAILED
}


var _status: Status = Status.PENDING

# @export var _backup_objective: Objective

func mark_complete() -> void:
  _status = Status.SUCCESS

func mark_failed() -> void:
  _status = Status.FAILED

func get_type() -> String:
  return _type

func set_type(type: String) -> void:
  _type = type

func get_status() -> Status:
  return _status
