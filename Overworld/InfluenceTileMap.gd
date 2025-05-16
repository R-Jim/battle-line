class_name InfluenceTilemap
extends TileMapLayer

# Configuration
@export var influence_decay: int = 1
@export var neutral_color: Color = Color(0.5, 0.5, 0.5)
@export var player_color: Color = Color(0, 0, 1)
@export var enemy_color: Color = Color(1, 0, 0)

# Node that contains all influencer nodes
@onready var influencers_node = $Influencers

# Dictionary to store calculated influence values: {Vector2i position: int value}
var influence_map = {}

# Hex directions for neighborhood calculation
const HEX_DIRECTIONS_ODD = [
    Vector2i(1, 0),   # East
    Vector2i(1, -1),  # Northeast
    Vector2i(0, -1),  # Northwest
    Vector2i(-1, 0),  # West
    Vector2i(0, 1),    # Southwest
    Vector2i(1, 1),   # Southeast
]

const HEX_DIRECTIONS_EVEN = [
    Vector2i(1, 0),   # East
    Vector2i(0, -1),  # Northeast
    Vector2i(-1, -1),  # Northwest
    Vector2i(-1, 0),  # West
    Vector2i(-1, 1),    # Southwest
    Vector2i(0, 1),   # Southeast
]

const HEX_DIRECTIONS = {
    true: HEX_DIRECTIONS_EVEN,
    false: HEX_DIRECTIONS_ODD,
}

func _ready():
    # Initial calculation
    calculate_influence()
    update_visuals()

# Call this when influencers are added/removed/changed
func update_influence():
    calculate_influence()
    update_visuals()

func calculate_influence():
    # Reset influence map
    influence_map.clear()
    
    # Process each influencer child node
    for influencer: Node2D in influencers_node.get_children():
        var pos = influencer.get_map_position()
        var strength = influencer.influence_strength
        if strength == 0:
            continue
        
        # Convert position to tilemap coordinates if needed
        var tile_pos = local_to_map(pos) if typeof(pos) == TYPE_VECTOR2 else pos
        
        # BFS to propagate influence
        var queue = []
        var visited = {}
        
        # Start with the influencer position at distance 0
        queue.push_back([tile_pos, 0])
        visited[tile_pos] = true
        
        while not queue.is_empty():
            var current = queue.pop_front()
            var current_pos = current[0]
            var distance = current[1]
            # Calculate influence at this position
            var decay = (distance * influence_decay)
            if strength < 0:
                decay *= -1
            var influence_value = strength - decay
            
            # Only continue propagation if there's still influence to spread
            if abs(influence_value) > 0:
                # Add influence to the influence map
                if not influence_map.has(current_pos):
                    influence_map[current_pos] = 0
                influence_map[current_pos] += influence_value
                
                # Add neighbors to the queue
                for dir in HEX_DIRECTIONS[current_pos.y % 2==0]:
                    var neighbor_pos = current_pos + dir
                    if not visited.has(neighbor_pos):
                        visited[neighbor_pos] = true
                        queue.push_back([neighbor_pos, distance + 1])

func update_visuals():
    # Clear existing visuals
    clear()
    
    # Update visuals based on influence map
    for tile_pos in influence_map:
        var influence_value = influence_map[tile_pos]
        var cell_color
        
        if influence_value > 0:
            cell_color = player_color
        elif influence_value < 0:
            cell_color = enemy_color
        else:
            cell_color = neutral_color
            
        # Set tile based on influence
        set_cell(tile_pos, 0, Vector2i.ZERO, 0 )
        
        # For coloring, use your preferred method:
        # Option 1: If using Godot 4.0+ with TileData modulate
        #var tile_data = get_cell_tile_data(tile_pos)
        #if tile_data:
            #tile_data.modulate = cell_color
            #
        # Option 2: Alternative - use ColorRect or Sprite as overlay
        var overlay = RichTextLabel.new()
        overlay.modulate = cell_color
        overlay.text = str(influence_value)
        overlay.position = map_to_local(tile_pos)
        overlay.size = Vector2(32, 32)
        add_child(overlay)

# Helper method to get influence value at a position
func get_influence_at(position: Vector2i) -> int:
    return influence_map.get(position, 0)
