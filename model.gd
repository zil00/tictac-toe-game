extends nodeclass
class_name Model
var tile_map_layer_from_model: Node2D 
var X_array = []
var O_array = []

	
# this class can prollyv check weather the clicked coordinate is empty or not
# so we need a function for that 
# I need to store all the values occupied
#maybe I can make two arrays for X and Y
func check_empty(coord: Vector2i):
	if coord not in X_array or O_array:
		X_array.append(coord)
		print(X_array)
	
