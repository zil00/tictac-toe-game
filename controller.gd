extends Node2D

var board_size:int
## Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#var used_rect = $TileMapLayer.get_used_rect().size.x
	pass
#
#
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass
func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			var click_global_pos = event.position
			#converts the global click into the tilemaps local position
			var click_map_pos = $TileMapLayer.local_to_map($TileMapLayer.to_local(click_global_pos))
			#the total map layer area
			var used_rect = $TileMapLayer.get_used_rect()
			
			if used_rect.has_point(click_map_pos):
				print("Click was INSIDE the used tilemap area!")
