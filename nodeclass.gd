extends Node2D
class_name nodeclass
var tile_map_layer: Node2D
var X_array 
var O_array 
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	tile_map_layer = $TileMapLayer
	X_array = []
	O_array = []
