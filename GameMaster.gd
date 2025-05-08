extends Node

var faction_commanders: Dictionary[int, Commander] = {}
var _process_commanders_timer: Timer

func _register_faction_commander(faction: int, commander: Commander):
  faction_commanders[faction] = commander
  print("registered commander for faction:", faction)

func _ready() -> void:
  _process_commanders_timer = Timer.new()
  _process_commanders_timer.wait_time = 5.0
  _process_commanders_timer.one_shot = false
  _process_commanders_timer.autostart = true
  _process_commanders_timer.timeout.connect(_process_commanders)
  add_child(_process_commanders_timer)

func _process_commanders():
  for faction in faction_commanders:
    var commander = faction_commanders[faction]
    if not commander:
        faction_commanders.erase(faction)
        continue
    
    commander.deploy_units()
    commander.command_units()
    if commander.is_completed():
      print("commander is completed for faction:", faction)
  return
