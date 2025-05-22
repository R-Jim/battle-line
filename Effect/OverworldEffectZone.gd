extends Area2D


@export var _faction: int
var effects: Array[SquadEffect] = []
var effected_node: Dictionary[Squad, Array] = {}

func _ready():
    self.body_entered.connect(_on_body_entered)
    self.body_exited.connect(_on_body_exited)
    
    for child in get_children():
        if child is SquadEffect:
            effects.append(child)


func _on_body_entered(node: Node):
    if node is not Squad:
        return
    
    if  effected_node.has(node):
        return
    
    var squad: Squad = node
    if squad.get_faction() != _faction:
        return
    print(squad.name)
    effected_node[squad] = []
    for effect in effects:
        var squad_effect = effect.duplicate()
        squad.add_effect(squad_effect)
        effected_node[squad].append(squad_effect)
    


func _on_body_exited(node: Node):
    if node is not Squad:
        return
    
    var squad: Squad = node
    print(squad.name, " exit")
    if  effected_node.has(squad):
        for effect in effected_node[squad]:
            effect.queue_free()
    effected_node.erase(squad)
