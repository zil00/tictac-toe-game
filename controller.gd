extends nodeclass
class_name Controller
var model:= Model.new()
@export var board: TileMapLayer
@onready var view: View = $TileMapLayer
@onready var game_over: Label = $gameover
@onready var re_start: Button = $restart
func _ready() -> void:
	if board == null:
		print("null")
	assert(view != null)
	model.x_played.connect(view._set_x)
	model.o_played.connect(view._set_o)
	model.game_over.connect(_on_game_over)
	model.board_reset.connect(_on_board_reset)
	model.send_X_array.connect(_on_board_reset)
	model.send_O_array.connect(_on_board_reset)
	
func _on_game_over(result: String) ->void:
	if result=="X Won":
		game_over.text = "X Won"
		game_over.visible = true
		await get_tree().create_timer(1.0).timeout
		re_start.visible = true
		
	elif result=="O Won":
		game_over.text = "O Won"
		game_over.visible = true
		await get_tree().create_timer(1.0).timeout
		re_start.visible = true
	elif result=="Cat Won":
		game_over.text="Cat Won"
		game_over.visible = true
		await get_tree().create_timer(1.0).timeout
		re_start.visible = true
	
	
	
	
	
func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			var click_global_pos = event.position
			#converts the global click into the tilemaps local position
			var click_map_pos = board.local_to_map(board.to_local(click_global_pos))
			#the total map layer area
			var used_rect = board.get_used_rect()
			
			if used_rect.has_point(click_map_pos):
				model.check_empty(click_map_pos)

func reset_game() -> void:
	game_over.visible = false
	model.reset()
	
func _on_board_reset(x: Array, o:Array) ->void:
	view.clear_board(x, o)


func _on_restart_pressed() -> void:
	_on_board_reset(model.O_array,model.X_array)
	reset_game()
	re_start.visible =false
