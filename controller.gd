extends Node2D
class_name Controller

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			var click_global_pos = event.position
			#converts the global click into the tilemaps local position
			var click_map_pos = $TileMapLayer.local_to_map($TileMapLayer.to_local(click_global_pos))
			#the total map layer area
			var used_rect = $TileMapLayer.get_used_rect()
			
			if used_rect.has_point(click_map_pos):
				var grid_coord: Vector2i = click_map_pos
				print(grid_coord)
