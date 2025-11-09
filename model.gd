extends nodeclass
class_name Model
var tile_map_layer_from_model: Node2D 
func _ready() -> void:
	tile_map_layer_from_model = tile_map_layer
	
# this class can prollyv check weather the clicked coordinate is empty or not
# so we need a function for that 
func check_empty(coord: Vector2i):
	print("")
	#converts the global click into the tilemaps local position
	#click_map_pos = $TileMapLayer.local_to_map($TileMapLayer.to_local(coord))
	##the total map layer area
	#var used_rect = $TileMapLayer.get_used_rect()
	#
	#if used_rect.has_point(click_map_pos):
		#var grid_coord: Vector2i = click_map_pos
		#print(grid_coord)
