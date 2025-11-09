class_name View
extends TileMapLayer

# set these to your correct tile source/atlas
@export var x_source_id: int = 0
@export var empty_source_id: int = 0
@export var x_atlas: Vector2i = Vector2i(1, 0)
@export var o_source_id: int = 0
@export var o_atlas: Vector2i = Vector2i(0, 0)
@export var empty_atlas: Vector2i = Vector2i(2, 0)

func _set_x(coord: Vector2i) -> void:
	set_cell(coord, x_source_id, x_atlas)   # since this node IS the TileMapLayer

func _set_o(coord: Vector2i) -> void:
	print(coord)
	set_cell(coord, o_source_id, o_atlas)

func clear_board(x: Array,o:Array) :
	for count in x:
		print(count)
		set_cell(count, empty_source_id, empty_atlas)
	for count in o:
		set_cell(count, empty_source_id, empty_atlas)
