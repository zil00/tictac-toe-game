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
	if coord not in X_array or O_array :
		#if the space has not been occupied then we change the decider
		turn_decider+=1
		if turn_decider%2 == 0:
			O_array.append(coord)
			print("'X's' turn")
			print(O_array)
		else:
			X_array.append(coord)
			win_check_x()
			print("'O's' turn")
			print(X_array)
		#print(X_array)
	else:
		print("space occupied !! Try Again !!")
func win_check_x():
	#check for same 3 x coordinates 
	var check_three_x=0
	for count in X_array:
		for index in X_array:
			if count.x == index.x:
				check_three_x+=1
				if check_three_x ==3:
					print("win")
					break
		check_three_x = 0
	#check for same 3 y coordinates
	var check_three_y=0
	for count in X_array:
		for index in X_array:
			if count.y == index.y:
				check_three_y+=1
				if check_three_y ==3:
					print("win")
					break
		check_three_y = 0
	#check for 3 x coordinates 0,1,2
	var check_diagonal = 0
	for count in X_array:
		if count.x == 0:
			check_diagonal+=1
		elif count.x == 1:
			check_diagonal+=1
		elif count.x == 2:
			check_diagonal+=1
		if check_diagonal ==3:
			print("win")
	
func win_check_o():
	#check for same 3 x coordinates 
	var check_three_x=0
	for count in O_array:
		for index in O_array:
			if count.x == index.x:
				check_three_x+=1
				if check_three_x ==3:
					print("win")
					break
		check_three_x = 0
	#check for same 3 y coordinates
	var check_three_y=0
	for count in O_array:
		for index in O_array:
			if count.y == index.y:
				check_three_y+=1
				if check_three_y ==3:
					print("win")
					break
		check_three_y = 0
	#check for 3 x coordinates 0,1,2
	var check_diagonal = 0
	for count in O_array:
		if count.x == 0:
			check_diagonal+=1
		elif count.x == 1:
			check_diagonal+=1
		elif count.x == 2:
			check_diagonal+=1
		if check_diagonal ==3:
			print("win")

func draw_check():
	print("draww")
