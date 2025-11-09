extends Model
class_name Controller
@export var board: TileMapLayer
func _ready() -> void:
	if board == null:
		print("null")
		
func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			var click_global_pos = event.position
			#converts the global click into the tilemaps local position
			var click_map_pos = board.local_to_map(board.to_local(click_global_pos))
			#the total map layer area
			var used_rect = board.get_used_rect()
			
			if used_rect.has_point(click_map_pos):
				check_empty(click_map_pos)
