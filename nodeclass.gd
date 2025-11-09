extends Node2D
class_name nodeclass
var tile_map_layer: Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	tile_map_layer = $TileMapLayer
