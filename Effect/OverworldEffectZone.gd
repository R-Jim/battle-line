extends Area2D


var effects: Array[SquadEffect] = []
var effected_node: Dictionary[Squad, Array] = {}

func _ready():
    self.area_entered.connect(_on_area_entered)
    self.area_exited.connect(_on_area_exited)
    
    for child in get_children():
        if child is SquadEffect:
            effects.append(child)


func _on_area_entered(area: Area2D):
    var node = area.get_parent()
    if node is not Squad:
        return
    
    if  effected_node.has(node):
        return
    
    var squad: Squad = node
    effected_node[squad] = []
    for effect in effects:
        var squad_effect = effect.duplicate()
        squad.add_effect(squad_effect)
        effected_node[node].append(squad_effect)
    


func _on_area_exited(area: Area2D):
    var node = area.get_parent()
    if node is not Squad:
        return
    
    var squad: Squad = node
    if  effected_node.has(squad):
        for effect in effected_node[squad]:
            effect.queue_free()
    effected_node.erase(squad)
