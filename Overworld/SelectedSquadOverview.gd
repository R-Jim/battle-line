extends PanelContainer

@onready var squad_card = $SquadCard
@export var squards: Node

func _process(delta: float) -> void:
    for squad: Squad in squards.get_children():
        if squad.selectable.is_selected():
            squad_card.set_squad(squad)
            squad_card.visible = true
            return
    
    squad_card.visible = false
