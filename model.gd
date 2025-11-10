extends nodeclass
class_name Model

# A reference to the TileMapLayer (not directly used here, but kept for structure)
var tile_map_layer_from_model: Node2D 

# Arrays holding coordinates where X or O has been placed
var X_array = []
var O_array = []

# Keeps track of whose turn it is (even = O, odd = X)
var turn_decider = -1

# Counts the total moves made so far (used for detecting draws)
var total_turns = 0

# Signals sent to Controller/View
signal x_played(pos: Vector2i)          # emitted when X is placed
signal o_played(pos: Vector2i)          # emitted when O is placed
signal game_over(result: String)        # emitted when the game ends with result
signal send_X_array(cords: Array)       # passes X positions during reset
signal send_O_array(cords: Array)       # passes O positions during reset
signal board_reset                      # emitted when board is cleared

# --------------------------------------------------------------------------
# check_empty() 
# Validates the clicked tile.
# Ensures the tile is NOT already occupied, then processes the move.
# Responsible for: switching turns, emitting signals, checking wins/draws.
# --------------------------------------------------------------------------
func check_empty(coord: Vector2i):
	# Check if tile is empty (not in either array)
	if (coord not in X_array) and (coord not in O_array):

		# Advance turn counter (determines whether X or O plays)
		turn_decider += 1

		# ------------------ O's TURN ----------------------------------------
		if turn_decider % 2 == 0: 
			total_turns += 1
			o_played.emit(coord)        # tell the View to draw O
			O_array.append(coord)       # record O's move

			# Check for win condition
			if win_check_o() == true:
				game_over.emit("O Won")
				return
			
			# Check for draw condition
			if draw_check() == true:
				game_over.emit("Cat Won")
				return

			print("'X's' turn")          # next player is X

		# ------------------ X's TURN ----------------------------------------
		else:
			total_turns += 1
			x_played.emit(coord)        # tell the View to draw X
			X_array.append(coord)       # record X's move

			# Check for win condition
			if win_check_x() == true:
				game_over.emit("X Won")
				return

			# Check for draw condition
			if draw_check() == true:
				game_over.emit("Cat Won")
				return

			print("'O's' turn")          # next player is O

	else:
		# Tile is already taken
		print("space occupied !! Try Again !!")


# --------------------------------------------------------------------------
# win_check_x()
# Checks whether X has formed 3 in a row.
# Checks columns, rows, and both diagonals.
# Returns true if X wins.
# --------------------------------------------------------------------------
func win_check_x() -> bool:
	var check_three_x = 0

	# Check vertical alignment (same x coordinate)
	for count in X_array:
		for index in X_array:
			if count.x == index.x:
				check_three_x += 1
				if check_three_x == 3:
					print("X won")
					return true
		check_three_x = 0

	# Check horizontal alignment (same y coordinate)
	var check_three_y = 0
	for count in X_array:
		for index in X_array:
			if count.y == index.y:
				check_three_y += 1
				if check_three_y == 3:
					print("X won")
					return true
		check_three_y = 0

	# Check main diagonal
	var check_diagonal = 0
	for count in X_array:
		if count.x == 0 and count.y == 0: check_diagonal += 1
		elif count.x == 1 and count.y == 1: check_diagonal += 1
		elif count.x == 2 and count.y == 2: check_diagonal += 1
		if check_diagonal == 3:
			print("O won here")
			return true

	# Check anti-diagonal
	check_diagonal = 0
	for count in X_array:
		if count.x == 2 and count.y == 0: check_diagonal += 1
		elif count.x == 1 and count.y == 1: check_diagonal += 1
		elif count.x == 0 and count.y == 2: check_diagonal += 1
		if check_diagonal == 3:
			print("O won here")
			return true

	return false


# --------------------------------------------------------------------------
# win_check_o()
# Same logic as win_check_x(), but checks O_array instead.
# Returns true if O wins.
# --------------------------------------------------------------------------
func win_check_o() -> bool:
	var check_three_x=0

	# Check vertical alignment
	for count in O_array:
		for index in O_array:
			if count.x == index.x:
				check_three_x += 1
				if check_three_x == 3:
					print("O won")
					return true
		check_three_x = 0

	# Check horizontal alignment
	var check_three_y = 0
	for count in O_array:
		for index in O_array:
			if count.y == index.y:
				check_three_y += 1
				if check_three_y == 3:
					print("O won")
					return true
		check_three_y = 0

	# Check main diagonal
	var check_diagonal = 0
	for count in O_array:
		if count.x == 0 and count.y == 0: check_diagonal += 1
		elif count.x == 1 and count.y == 1: check_diagonal += 1
		elif count.x == 2 and count.y == 2: check_diagonal += 1
		if check_diagonal == 3:
			print("O won here")
			return true

	# Check anti-diagonal
	check_diagonal = 0
	for count in O_array:
		if count.x == 2 and count.y == 0: check_diagonal += 1
		elif count.x == 1 and count.y == 1: check_diagonal += 1
		elif count.x == 0 and count.y == 2: check_diagonal += 1
		if check_diagonal == 3:
			print("O won here")
			return true

	return false


# --------------------------------------------------------------------------
# draw_check()
# If 9 moves have been played (0–8 indexes), the game is a draw.
# --------------------------------------------------------------------------
func draw_check() -> bool:
	if total_turns > 8:
		print("the cat won the game")
		print(total_turns)
		return true
	else:
		return false


# --------------------------------------------------------------------------
# reset()
# Clears the board state and emits signals so the Controller/View
# can visually reset the board.
# --------------------------------------------------------------------------
func reset() -> void:
	# Send the coordinates to the View for clearing
	send_O_array.emit(O_array)
	send_X_array.emit(X_array)

	# Reset internal state
	X_array.clear()
	O_array.clear()
	turn_decider = -1
	total_turns = 0

	# Inform controller that board should be reset visually
	board_reset.emit()
