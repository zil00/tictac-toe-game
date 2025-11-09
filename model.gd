extends nodeclass
class_name Model
var tile_map_layer_from_model: Node2D 
var X_array = []
var O_array = []
var turn_decider = -1 #if 0 then O if 1 then X
var total_turns = 0 #keeps track of the total number of turns taken 
signal x_played(pos: Vector2i)
signal o_played(pos: Vector2i)
signal game_over(result: String)
signal send_X_array(cords: Array)
signal send_O_array(cords: Array)
signal board_reset
# this class can prollyv check weather the clicked coordinate is empty or not
# so we need a function for that 
# I need to store all the values occupied
#maybe I can make two arrays for X and Y
func check_empty(coord: Vector2i):
	if (coord not in X_array) and (coord not in O_array):
		#if the space has not been occupied then we change the decider
		turn_decider+=1
		if turn_decider%2 == 0: #for when o played
			total_turns+=1
			o_played.emit(coord)
			O_array.append(coord)
			if win_check_o() == true:
				game_over.emit("O Won")
				return
			
			if draw_check() == true:
				game_over.emit("Cat Won")
				return
			print("'X's' turn")
		else:
			total_turns+=1
			x_played.emit(coord)
			X_array.append(coord)
			
			if win_check_x() == true:
				game_over.emit("X Won")
				return
			
			if draw_check() == true:
				game_over.emit("Cat Won")
				return
			print("'O's' turn")
		#print(X_array)
	else:
		print("space occupied !! Try Again !!")
func win_check_x() -> bool:
	#check for same 3 x coordinates 
	var check_three_x=0
	for count in X_array:
		for index in X_array:
			if count.x == index.x:
				check_three_x+=1
				if check_three_x ==3:
					print("X won")
					return true
		check_three_x = 0
	#check for same 3 y coordinates
	var check_three_y=0
	for count in X_array:
		for index in X_array:
			if count.y == index.y:
				check_three_y+=1
				if check_three_y ==3:
					print("X won")
					return true
		check_three_y = 0
	#check for 3 x coordinates 0,1,2
	var check_diagonal = 0
	for count in X_array:
		if count.x == 0 and count.y==0:
			check_diagonal+=1
		elif count.x == 1 and count.y==1:
			check_diagonal+=1
		elif count.x == 2 and count.y==2:
			check_diagonal+=1
		if check_diagonal == 3:
			print("O won here")
			return true
	check_diagonal=0
	for count in X_array:
		if count.x == 2 and count.y==0:
			check_diagonal+=1
		elif count.x == 1 and count.y==1:
			check_diagonal+=1
		elif count.x == 0 and count.y==2:
			check_diagonal+=1
		if check_diagonal == 3:
			print("O won here")
			return true
	check_diagonal = 0
	return false
	
func win_check_o() -> bool:
	#check for same 3 x coordinates 
	var check_three_x=0
	for count in O_array:
		for index in O_array:
			if count.x == index.x:
				check_three_x+=1
				if check_three_x ==3:
					print("O won")
					return true
		check_three_x = 0
	#check for same 3 y coordinates
	var check_three_y=0
	for count in O_array:
		for index in O_array:
			if count.y == index.y:
				check_three_y+=1
				if check_three_y ==3:
					print("O won")
					return true
		check_three_y = 0
	#check for 3 x coordinates 0,1,2
	var check_diagonal = 0
	for count in O_array:
		if count.x == 0 and count.y==0:
			check_diagonal+=1
		elif count.x == 1 and count.y==1:
			check_diagonal+=1
		elif count.x == 2 and count.y==2:
			check_diagonal+=1
		if check_diagonal == 3:
			print("O won here")
			return true
	check_diagonal =0
	for count in O_array:
		if count.x == 2 and count.y==0:
			check_diagonal+=1
		elif count.x == 1 and count.y==1:
			check_diagonal+=1
		elif count.x == 0 and count.y==2:
			check_diagonal+=1
		if check_diagonal == 3:
			print("O won here")
			return true
	check_diagonal = 0
	return false

func draw_check() -> bool:
	if total_turns > 8 :
		print("the cat won the game")
		print(total_turns)
		return true
	else:
		return false
		
func reset() -> void:
	send_O_array.emit(O_array)
	send_X_array.emit(X_array)
	X_array.clear()
	O_array.clear()
	turn_decider = -1
	total_turns = 0
	board_reset.emit()
