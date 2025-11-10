class_name View
extends TileMapLayer

# --------------------------------------------------------------------------
# Exported tile parameters for drawing X, O, and empty cells.
# These values depend on how your spritesheet is arranged in the TileSet.
# --------------------------------------------------------------------------

@export var x_source_id: int = 0          # TileSet source ID for X tiles
@export var empty_source_id: int = 0      # TileSet source ID for clearing tiles
@export var x_atlas: Vector2i = Vector2i(1, 0)   # Atlas coordinates for X tile
@export var o_source_id: int = 0          # TileSet source ID for O tiles
@export var o_atlas: Vector2i = Vector2i(0, 0)   # Atlas coordinates for O tile
@export var empty_atlas: Vector2i = Vector2i(2, 0) # Atlas coordinates for empty tile


# --------------------------------------------------------------------------
# _set_x()
# Draws an X onto the board at the given coordinate.
# Called by the Controller when Model emits x_played().
# --------------------------------------------------------------------------
func _set_x(coord: Vector2i) -> void:
	set_cell(coord, x_source_id, x_atlas)   # Places X sprite in the TileMap


# --------------------------------------------------------------------------
# _set_o()
# Draws an O onto the board at the given coordinate.
# Called by the Controller when Model emits o_played().
# --------------------------------------------------------------------------
func _set_o(coord: Vector2i) -> void:
	print(coord)                             # Debug: prints tile position
	set_cell(coord, o_source_id, o_atlas)    # Places O sprite in the TileMap


# --------------------------------------------------------------------------
# clear_board(x_array, o_array)
# Removes all X and O tiles from the board.
# Controller passes in the exact coordinates to clear.
# Replaces the tiles with the "empty" tiles from the tile atlas.
# --------------------------------------------------------------------------
func clear_board(x: Array, o: Array):
	# Clear all X tiles
	for count in x:
		print(count)                          # Debug: shows cleared X tiles
		set_cell(count, empty_source_id, empty_atlas)

	# Clear all O tiles
	for count in o:
		set_cell(count, empty_source_id, empty_atlas)
