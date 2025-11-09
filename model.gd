extends nodeclass
class_name Model
var tile_map_layer_from_model: Node2D 
var X_array = []
var O_array = []
var turn_decider = -1 #if 0 then O if 1 then X

# this class can prollyv check weather the clicked coordinate is empty or not
# so we need a function for that 
# I need to store all the values occupied
#maybe I can make two arrays for X and Y
func check_empty(coord: Vector2i):
	if coord not in X_array or O_array:
		#if the space has not been occupied then we change the decider
		turn_decider+=1
		if turn_decider%2 == 0:
			O_array.append(coord)
			print("'X's' turn")
			print(O_array)
		else:
			X_array.append(coord)
			print("'O's' turn")
			print(X_array)
		#print(X_array)
	else:
		print("space occupied !! Try Again !!")
	
