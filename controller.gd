extends nodeclass
class_name Controller

# The game model (game logic, win checking, turn handling)
var model := Model.new()

# Reference to the TileMapLayer that represents the board
@export var board: TileMapLayer

# Reference to the View node in the scene (TileMapLayer)
@onready var view: View = $TileMapLayer

# UI label that displays the game result ("X Won", "O Won", "Cat Won")
@onready var game_over: Label = $gameover

# Restart button that appears after the game ends
@onready var re_start: Button = $restart


# --------------------------------------------------------------------------
# _ready()
# Runs when the Controller enters the scene tree.
# Ensures required nodes exist and connects all Model signals to callbacks.
# --------------------------------------------------------------------------
func _ready() -> void:
	# Safety check: ensure board was assigned in the Inspector
	if board == null:
		print("null")
	
	# Ensure view exists — prevents errors
	assert(view != null)
	
	# Connect Model signals to View's tile update functions
	model.x_played.connect(view._set_x)        # draw X on the board
	model.o_played.connect(view._set_o)        # draw O on the board

	# Connect game-over signal to this controller's UI handler
	model.game_over.connect(_on_game_over)

	# Connect board reset events to clear the View
	model.board_reset.connect(_on_board_reset)
	model.send_X_array.connect(_on_board_reset)
	model.send_O_array.connect(_on_board_reset)


# --------------------------------------------------------------------------
# _on_game_over(result)
# Displays which player won or if the game ended in a draw.
# Shows the restart button after a short delay.
# --------------------------------------------------------------------------
func _on_game_over(result: String) -> void:
	if result == "X Won":
		game_over.text = "X Won"
		game_over.visible = true
		await get_tree().create_timer(1.0).timeout
		re_start.visible = true

	elif result == "O Won":
		game_over.text = "O Won"
		game_over.visible = true
		await get_tree().create_timer(1.0).timeout
		re_start.visible = true

	elif result == "Cat Won":
		game_over.text = "Cat Won"
		game_over.visible = true
		await get_tree().create_timer(1.0).timeout
		re_start.visible = true


# --------------------------------------------------------------------------
# _input(event)
# Handles mouse input → converts the click to tile coordinates.
# Passes the clicked tile coordinate to the Model for validation and updates.
# --------------------------------------------------------------------------
func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:

			# Screen-space click position
			var click_global_pos = event.position

			# Convert screen position → local TileMap coordinate
			var click_map_pos = board.local_to_map(board.to_local(click_global_pos))

			# Used area of the TileMapLayer (3x3 for tic-tac-toe)
			var used_rect = board.get_used_rect()
			
			# Only allow clicks inside the valid grid
			if used_rect.has_point(click_map_pos):
				model.check_empty(click_map_pos)   # forward to Model


# --------------------------------------------------------------------------
# reset_game()
# Resets UI and triggers the Model to clear its internal state.
# --------------------------------------------------------------------------
func reset_game() -> void:
	game_over.visible = false          # hide game-over label
	model.reset()                      # reset Model state (arrays, turns)


# --------------------------------------------------------------------------
# _on_board_reset(x, o)
# Clears visual board tiles using arrays received from Model.
# --------------------------------------------------------------------------
func _on_board_reset(x: Array, o: Array) -> void:
	view.clear_board(x, o)             # remove X/O graphics


# --------------------------------------------------------------------------
# _on_restart_pressed()
# Button handler to fully reset board and hide restart button.
# --------------------------------------------------------------------------
func _on_restart_pressed() -> void:
	_on_board_reset(model.O_array, model.X_array)  # clear board immediately
	reset_game()                                    # reset internal state
	re_start.visible = false                        # hide restart button again
