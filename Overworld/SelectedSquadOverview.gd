extends PanelContainer

@onready var squad_card = $SquadCard
@export var squards: Node

func _process(_delta: float) -> void:
    if InputState.get_current_state() != &"SELECT_OWN_SQUAD" and InputState.get_current_state() != &"SELECT_OTHER_SQUAD":
        squad_card.visible = false
        return
        
    var input_data = InputState.get_current_state_data()
    if input_data is not Squad:
        squad_card.visible = false
        return
        
    var squad: Squad = input_data
    squad_card.set_squad(squad)
    squad_card.visible = true
    return
