# res://tests/test_model.gd
extends GutTest

# Helper fields to spy on signals without relying on specific GUT signal helpers.
var model: Model

var seen_x_played: Array[Vector2i]
var seen_o_played: Array[Vector2i]
var seen_game_over: Array[String]
var seen_send_X: Array
var seen_send_O: Array
var board_reset_count: int

func before_each() -> void:
	# Fresh instance and fresh signal spy arrays for each test
	model = Model.new()
	seen_x_played = []
	seen_o_played = []
	seen_game_over = []
	seen_send_X = []
	seen_send_O = []
	board_reset_count = 0

	# Wire up signal watchers
	model.x_played.connect(func(pos: Vector2i): seen_x_played.append(pos))
	model.o_played.connect(func(pos: Vector2i): seen_o_played.append(pos))
	model.game_over.connect(func(result: String): seen_game_over.append(result))
	model.send_X_array.connect(func(arr: Array): seen_send_X.append(arr.duplicate()))
	model.send_O_array.connect(func(arr: Array): seen_send_O.append(arr.duplicate()))
	model.board_reset.connect(func(): board_reset_count += 1)

# --- small helpers ------------------------------------------------------------

func _play_many(coords: Array) -> void:
	# coords is an Array[Vector2i]
	for c in coords:
		model.check_empty(c)

func _assert_no_game_over() -> void:
	assert_eq(seen_game_over.size(), 0, "No game_over should have been emitted yet")

func _assert_last_game_over_is(expected: String) -> void:
	assert_gt(seen_game_over.size(), 0, "game_over should have been emitted")
	assert_eq(seen_game_over.back(), expected, "game_over result should match")

# --- tests --------------------------------------------------------------------

func test_first_turn_is_O_then_X() -> void:
	# turn_decider starts at -1; first valid move increments to 0 (O), then 1 (X)
	model.check_empty(Vector2i(0, 0))
	assert_eq(model.total_turns, 1)
	assert_eq(seen_o_played, [Vector2i(0, 0)], "First move should be O")
	assert_eq(seen_x_played.size(), 0)

	model.check_empty(Vector2i(1, 0))
	assert_eq(model.total_turns, 2)
	assert_eq(seen_x_played, [Vector2i(1, 0)], "Second move should be X")

func test_emits_signals_on_valid_moves_and_updates_arrays() -> void:
	model.check_empty(Vector2i(0, 0)) # O
	model.check_empty(Vector2i(2, 2)) # X
	assert_eq(seen_o_played, [Vector2i(0, 0)])
	assert_eq(seen_x_played, [Vector2i(2, 2)])
	assert_true(Vector2i(0, 0) in model.O_array)
	assert_true(Vector2i(2, 2) in model.X_array)
	_assert_no_game_over()

func test_ignores_occupied_tile_no_turn_increment_no_signal() -> void:
	# O plays at (1,1)
	model.check_empty(Vector2i(1, 1))
	var turns_before: int = int(model.total_turns)

	# Try to play again on (1,1) - should do nothing (just print)
	model.check_empty(Vector2i(1, 1))

	assert_eq(model.total_turns, turns_before, "Turns should not increase on occupied tile")
	# O should still only have one emission; X none
	assert_eq(seen_o_played.size(), 1, "No extra O signal")
	assert_eq(seen_x_played.size(), 0, "No X signal yet")
	_assert_no_game_over()

func test_O_wins_with_column() -> void:
	# O plays (0,0), X (1,0), O (0,1), X (1,1), O (0,2) -> O column win
	_play_many([
		Vector2i(0, 0), # O
		Vector2i(1, 0), # X
		Vector2i(0, 1), # O
		Vector2i(1, 1), # X
		Vector2i(0, 2)  # O -> should win via same x (column)
	])
	_assert_last_game_over_is("O Won")

func test_X_wins_with_row() -> void:
	# O plays (2,2), X (0,0), O (1,2), X (1,0), O (2,1), X (2,0) -> X wins row y=0
	_play_many([
		Vector2i(2, 2), # O
		Vector2i(0, 0), # X
		Vector2i(1, 2), # O
		Vector2i(1, 0), # X
		Vector2i(2, 1), # O
		Vector2i(2, 0)  # X -> row y==0 for X: (0,0),(1,0),(2,0)
	])
	_assert_last_game_over_is("X Won")

func test_X_wins_main_diagonal() -> void:
	# O: (2,0), X: (0,0), O: (2,1), X: (1,1), O: (1,2), X: (2,2) => X on (0,0),(1,1),(2,2)
	_play_many([
		Vector2i(2, 0), # O
		Vector2i(0, 0), # X
		Vector2i(2, 1), # O
		Vector2i(1, 1), # X
		Vector2i(1, 2), # O
		Vector2i(2, 2)  # X -> diagonal
	])
	_assert_last_game_over_is("X Won")

func test_O_wins_anti_diagonal() -> void:
	# O: (2,0), X: (0,0), O: (1,1), X: (1,0), O: (0,2) => O on (2,0),(1,1),(0,2)
	_play_many([
		Vector2i(2, 0), # O
		Vector2i(0, 0), # X
		Vector2i(1, 1), # O
		Vector2i(1, 0), # X
		Vector2i(0, 2)  # O -> anti-diagonal
	])
	_assert_last_game_over_is("O Won")

func test_draw_cat_wins_on_ninth_move() -> void:
	# Fill the board with no winner
	# Move order (O then X alternating):
	# O(0,0), X(1,1), O(2,2), X(0,1), O(0,2), X(2,0), O(1,0), X(1,2), O(2,1)
	_play_many([
		Vector2i(0, 0), # O
		Vector2i(1, 1), # X
		Vector2i(2, 2), # O
		Vector2i(0, 1), # X
		Vector2i(0, 2), # O
		Vector2i(2, 0), # X
		Vector2i(1, 0), # O
		Vector2i(1, 2), # X
		Vector2i(2, 1)  # O -> total_turns = 9 => Cat Won
	])
	_assert_last_game_over_is("Cat Won")
	assert_true(model.total_turns > 8, "total_turns should exceed 8 to trigger draw_check()")

func test_reset_clears_state_and_emits() -> void:
	# Make a couple of moves, then reset
	model.check_empty(Vector2i(0, 0)) # O
	model.check_empty(Vector2i(1, 0)) # X
	assert_gt(model.total_turns, 0)

	model.reset()

	# send_X_array and send_O_array should have emitted the pre-reset arrays once each
	assert_eq(seen_send_O.size(), 1, "send_O_array should have been emitted once")
	assert_eq(seen_send_X.size(), 1, "send_X_array should have been emitted once")
	assert_eq(board_reset_count, 1, "board_reset should have been emitted once")

	# And internal state cleared
	assert_eq(model.X_array.size(), 0, "X_array cleared")
	assert_eq(model.O_array.size(), 0, "O_array cleared")
	assert_eq(model.total_turns, 0, "total_turns reset")
	assert_eq(model.turn_decider, -1, "turn_decider reset")

func test_no_win_no_draw_during_partial_game() -> void:
	_play_many([
		Vector2i(0, 0), # O
		Vector2i(1, 0), # X
		Vector2i(2, 0), # O
		Vector2i(0, 1), # X
	])
	_assert_no_game_over()
