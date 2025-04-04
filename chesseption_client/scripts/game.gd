class_name Game extends Node2D

@onready var board = $Board
@onready var selection_window: Selection_window = $Selection_window
@onready var diamond = $Diamond
@onready var puff = $Puff
@onready var challange_window = $ChallangeAPlayerWindow

@onready var white_piece = $Pieces/White_piece
@onready var black_piece = $Pieces/Black_piece
@onready var red_piece = $Pieces/Red_piece
@onready var blue_piece = $Pieces/Blue_piece

@onready var box: Array = [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1] #This is temporary, real box will be assigned by the server


var your_color = ""
var your_piece = ""
var your_king = null #the piece you will be controling
var your_king_position = ""

func _ready() -> void:
	white_piece.set_piece_color("white")
	black_piece.set_piece_color("black")
	red_piece.set_piece_color("red")
	blue_piece.set_piece_color("blue")
	
	challange_window.connect("move_challanged", Callable(self, ("_on_move_challanged")))
	
	for tile in board.get_children():
		if tile is Tile:
			tile.connect("piece_moved", Callable(self, "_on_piece_moved"))
			
	set_your_king()
	diamond.animation.play("diamond_animation")
	
	your_turn()

func _on_move_challanged() -> void:
	challange_window.hide()
	#either calculate new board state based of player lied or diidnt and send it to server, 
	#or just send it to the server and let it calcualte new board state.
	#Either way server sends new board state to every player with message playerX challanged playerY and playerY lied/diidnt lie
	
func your_turn() -> void:
	free_all_ocupied_spaces()
	draw_board()
	draw_your_selection_window()
	var piece_name = get_random_piece_from_the_box(box)
	print(box) #for testing only
	selection_window.underline_this_piece(piece_name)
	#make a move
	#update game state info
	#send it to the server

func get_random_piece_from_the_box(box) -> String:
	var available_indexes = []
	
	for i in range(box.size()):
		if box[i] == 1:
			available_indexes.append(i)

	if available_indexes.is_empty():
		return "box is empty"
	
	var chosen_index = available_indexes[randi() % available_indexes.size()]
	box[chosen_index] = 0

	if chosen_index <= 7:
		return "pawn"
	elif chosen_index <= 9:
		return "bishop"
	elif chosen_index <= 11:
		return "knight"
	elif chosen_index <= 13:
		return "rook"
	elif chosen_index == 14:
		return "queen"
	else:
		return "something went wrong"
	
func free_all_ocupied_spaces() -> void:
	pass
func _on_piece_moved(new_tile_name: String) -> void:
	puff.position = board.get_node(NodePath(your_king_position)).global_position
	puff.animation.play("puff_animation")
	board.get_node(NodePath(your_king_position)).tile_is_occupied = false

	your_king_position = new_tile_name
	await get_tree().create_timer(0.6).timeout
	your_king.set_piece_sprite(your_piece)
	await get_tree().create_timer(0.15).timeout
	if check_if_tile_is_occupied(tile_name_to_matrix_representation(new_tile_name)):
		remove_piece_from_this_tile(new_tile_name)
	
	your_king.position = board.get_node(new_tile_name).global_position + Vector2(0, -10)
	board.get_node(new_tile_name).tile_is_occupied = true
	#if underlined_piece_that_was_pulled_out_of_the_box == your_king.this_piece:
	#	MultiplayerManager.make_move(multiplayer.get_unique_id(), your_king.your_tile_name, your_king.this_piece, false)
	#else:
	#	MultiplayerManager.make_move(multiplayer.get_unique_id(), your_king.your_tile_name, your_king.this_piece, true)
	
	if your_color == "white":
		board.white_piece_position = board.get_node(NodePath(your_king_position))
	if your_color == "black":
		board.black_piece_position = board.get_node(NodePath(your_king_position))
	if your_color == "red":
		board.red_piece_position = board.get_node(NodePath(your_king_position))
	if your_color == "blue":
		board.blue_piece_position = board.get_node(NodePath(your_king_position))
		
	unhighlight_all_squares()
	selection_window.remove_underline()
	
	your_turn()
	challange_window.show()
	
func remove_piece_from_this_tile(new_tile_name: String) -> void:
	if board.white_piece_position.name == new_tile_name:
		board.white_piece_position = board.removed_pieces
		white_piece.position = board.removed_pieces.global_position 
	if board.black_piece_position.name == new_tile_name:
		board.black_piece_position = board.removed_pieces
		black_piece.position = board.removed_pieces.global_position 
	if board.red_piece_position.name == new_tile_name:
		board.red_piece_position = board.removed_pieces
		red_piece.position = board.removed_pieces.global_position 
	if board.blue_piece_position.name == new_tile_name:
		board.blue_piece_position = board.removed_pieces
		blue_piece.position = board.removed_pieces.global_position 

	if board.diamond_position.name == new_tile_name:
		board.diamond_position = board.removed_pieces
		diamond.position = board.removed_pieces.global_position

func draw_your_selection_window() -> void:
	selection_window.set_your_color(your_color)
	selection_window.connect("piece_chosen", Callable(self, "_on_piece_chosen"))

func _on_piece_chosen(piece_name: String) -> void:
	if your_piece != "king":
		unhighlight_all_squares()

	your_piece = piece_name
	highlight_available_tiles()
	
func set_your_king() -> void:
	your_color = "white"
	your_piece = "king"
	your_king = white_piece
	your_king_position = board.white_piece_position.name
	
func draw_board() -> void:
	white_piece.global_position = board.white_piece_position.global_position + Vector2(0, -10)
	board.white_piece_position.tile_is_occupied = true
	black_piece.global_position = board.black_piece_position.global_position + Vector2(0, -10)
	board.black_piece_position.tile_is_occupied = true
	red_piece.global_position = board.red_piece_position.global_position + Vector2(0, -10)
	board.red_piece_position.tile_is_occupied = true
	blue_piece.global_position = board.blue_piece_position.global_position + Vector2(0, -10)
	board.blue_piece_position.tile_is_occupied = true
	#red_piece.global_position = board.red_piece_position.global_position + Vector2(0, -10)
	#board.red_piece_position.tile_is_occupied = true
	#blue_piece.global_position = board.blue_piece_position.global_position + Vector2(0, -10)
	#board.blue_piece_position.tile_is_occupied = true
	
	#THIS POSITION WILL BE ASSIGNED BY SERVER
	board.diamond_position = board.get_node("c6")
	diamond.position = board.diamond_position.global_position + Vector2(0, 0)
	board.diamond_position.tile_is_occupied = true
	
func highlight_available_tiles() -> void:
	var available_tiles_array: Array = []
	var occupied_but_available_tiles_array: Array = []
	var coord: Vector2 = tile_name_to_matrix_representation(your_king_position)
	if your_piece == "pawn":
		var new_coords_green = []
		var new_coords_red = []
		var next_tile
		if your_color == "white":
			next_tile = coord + Vector2(-1, 1)
			if check_if_tile_is_occupied(next_tile):
				new_coords_red.append(next_tile)
			next_tile = coord + Vector2(0, 1)
			if !check_if_tile_is_occupied(next_tile):
				new_coords_green.append(next_tile)
			next_tile = coord + Vector2(1, 1)
			if check_if_tile_is_occupied(next_tile):
				new_coords_red.append(next_tile)
		elif your_color == "black":
			next_tile = coord + Vector2(-1, -1)
			if check_if_tile_is_occupied(next_tile):
				new_coords_red.append(next_tile)
			next_tile = coord + Vector2(0, -1)
			if !check_if_tile_is_occupied(next_tile):
				new_coords_green.append(next_tile)
			next_tile = coord + Vector2(1, -1)
			if check_if_tile_is_occupied(next_tile):
				new_coords_red.append(next_tile)
		elif your_color == "red":
			next_tile = coord + Vector2(-1, -1)
			if check_if_tile_is_occupied(next_tile):
				new_coords_red.append(next_tile)
			next_tile = coord + Vector2(-1, 0)
			if !check_if_tile_is_occupied(next_tile):
				new_coords_green.append(next_tile)
			next_tile = coord + Vector2(-1, 1)
			if check_if_tile_is_occupied(next_tile):
				new_coords_red.append(next_tile)
		elif your_color == "blue":
			next_tile = coord + Vector2(1, -1)
			if check_if_tile_is_occupied(next_tile):
				new_coords_red.append(next_tile)
			next_tile = coord + Vector2(1, 0)
			if !check_if_tile_is_occupied(next_tile):
				new_coords_green.append(next_tile)
			next_tile = coord + Vector2(1, 1)
			if check_if_tile_is_occupied(next_tile):
				new_coords_red.append(next_tile)
		available_tiles_array = new_coords_green.filter(is_valid).map(matrix_representation_to_tile_name)
		occupied_but_available_tiles_array = new_coords_red.filter(is_valid).map(matrix_representation_to_tile_name)
	
	if your_piece == "bishop":
		var new_coords_green = []
		var new_coords_red = []
		var next_tile
		for i in range(1,4): #north-east direction
			next_tile = coord + Vector2(i,i)
			if check_if_tile_is_occupied(next_tile):
				new_coords_red.append(next_tile)
				break
			else:
				new_coords_green.append(next_tile)
		
		for i in range(1,4): #north-west direction
			next_tile = coord + Vector2(-i,i)
			if check_if_tile_is_occupied(next_tile):
				new_coords_red.append(next_tile)
				break
			else:
				new_coords_green.append(next_tile)
 
		for i in range(1,4): #south-east direction
			next_tile = coord + Vector2(i,-i)
			if check_if_tile_is_occupied(next_tile):
				new_coords_red.append(next_tile)
				break
			else:
				new_coords_green.append(next_tile)
		
		for i in range(1,4): # south-west direction
			next_tile = coord + Vector2(-i,-i)
			if check_if_tile_is_occupied(next_tile):
				new_coords_red.append(next_tile)
				break
			else:
				new_coords_green.append(next_tile)
		available_tiles_array = new_coords_green.filter(is_valid).map(matrix_representation_to_tile_name)
		occupied_but_available_tiles_array = new_coords_red.filter(is_valid).map(matrix_representation_to_tile_name)

	if your_piece == "knight":
		var new_coords_green = []
		var new_coords_red = []
		var next_tile
		next_tile = coord + Vector2(1,2)
		if check_if_tile_is_occupied(next_tile):
			new_coords_red.append(next_tile)
		else:
			new_coords_green.append(next_tile)
		next_tile = coord + Vector2(1,-2)
		if check_if_tile_is_occupied(next_tile):
			new_coords_red.append(next_tile)
		else:
			new_coords_green.append(next_tile)
		next_tile = coord + Vector2(-1,2)
		if check_if_tile_is_occupied(next_tile):
			new_coords_red.append(next_tile)
		else:
			new_coords_green.append(next_tile)
		next_tile = coord + Vector2(-1,-2)
		if check_if_tile_is_occupied(next_tile):
			new_coords_red.append(next_tile)
		else:
			new_coords_green.append(next_tile)
		next_tile = coord + Vector2(2,1)
		if check_if_tile_is_occupied(next_tile):
			new_coords_red.append(next_tile)
		else:
			new_coords_green.append(next_tile)
		next_tile = coord + Vector2(2,-1)
		if check_if_tile_is_occupied(next_tile):
			new_coords_red.append(next_tile)
		else:
			new_coords_green.append(next_tile)
		next_tile = coord + Vector2(-2,1)
		if check_if_tile_is_occupied(next_tile):
			new_coords_red.append(next_tile)
		else:
			new_coords_green.append(next_tile)
		next_tile = coord + Vector2(-2,-1)
		if check_if_tile_is_occupied(next_tile):
			new_coords_red.append(next_tile)
		else:
			new_coords_green.append(next_tile)

		available_tiles_array = new_coords_green.filter(is_valid).map(matrix_representation_to_tile_name)
		occupied_but_available_tiles_array = new_coords_red.filter(is_valid).map(matrix_representation_to_tile_name)

		
	if your_piece == "rook":
		var new_coords_green = []
		var new_coords_red = []
		var next_tile
		for i in range(1,4): #north-west direction
			next_tile = coord + Vector2(0,i)
			if check_if_tile_is_occupied(next_tile):
				new_coords_red.append(next_tile)
				break
			else:
				new_coords_green.append(next_tile)
		
		for i in range(1,4): #north-west direction
			next_tile = coord + Vector2(0,-i)
			if check_if_tile_is_occupied(next_tile):
				new_coords_red.append(next_tile)
				break
			else:
				new_coords_green.append(next_tile)
				
		for i in range(1,4): #north-west direction
			next_tile = coord + Vector2(i,0)
			if check_if_tile_is_occupied(next_tile):
				new_coords_red.append(next_tile)
				break
			else:
				new_coords_green.append(next_tile)
				
		for i in range(1,4): #north-west direction
			next_tile = coord + Vector2(-i,0)
			if check_if_tile_is_occupied(next_tile):
				new_coords_red.append(next_tile)
				break
			else:
				new_coords_green.append(next_tile)
				
		available_tiles_array = new_coords_green.filter(is_valid).map(matrix_representation_to_tile_name)
		occupied_but_available_tiles_array = new_coords_red.filter(is_valid).map(matrix_representation_to_tile_name)
	
	if your_piece == "queen":
		var new_coords_green = []
		var new_coords_red = []
		var next_tile
		for i in range(1,5): #north-west direction
			next_tile = coord + Vector2(i,i)
			if check_if_tile_is_occupied(next_tile):
				new_coords_red.append(next_tile)
				break
			else:
				new_coords_green.append(next_tile)
		
		for i in range(1,5): #south-west direction
			next_tile = coord + Vector2(i,-i)
			if check_if_tile_is_occupied(next_tile):
				new_coords_red.append(next_tile)
				break
			else:
				new_coords_green.append(next_tile)
		
		for i in range(1,5): #north-west direction
			next_tile = coord + Vector2(-i,i)
			if check_if_tile_is_occupied(next_tile):
				new_coords_red.append(next_tile)
				break
			else:
				new_coords_green.append(next_tile)
		
		for i in range(1,5): #south-west direction
			next_tile = coord + Vector2(-i,-i)
			if check_if_tile_is_occupied(next_tile):
				new_coords_red.append(next_tile)
				break
			else:
				new_coords_green.append(next_tile)
				
		for i in range(1,5): #east direction
			next_tile = coord + Vector2(i,0)
			if check_if_tile_is_occupied(next_tile):
				new_coords_red.append(next_tile)
				break
			else:
				new_coords_green.append(next_tile)
				
		for i in range(1,5): #west direction
			next_tile = coord + Vector2(-i,0)
			if check_if_tile_is_occupied(next_tile):
				new_coords_red.append(next_tile)
				break
			else:
				new_coords_green.append(next_tile)
		
		for i in range(1,5): #north direction
			next_tile = coord + Vector2(0,i)
			if check_if_tile_is_occupied(next_tile):
				new_coords_red.append(next_tile)
				break
			else:
				new_coords_green.append(next_tile)
		
		for i in range(1,5): #south direction
			next_tile = coord + Vector2(0,-i)
			if check_if_tile_is_occupied(next_tile):
				new_coords_red.append(next_tile)
				break
			else:
				new_coords_green.append(next_tile)

		available_tiles_array = new_coords_green.filter(is_valid).map(matrix_representation_to_tile_name)
		occupied_but_available_tiles_array = new_coords_red.filter(is_valid).map(matrix_representation_to_tile_name)
		
	for tile in board.get_children():
		if tile.name in available_tiles_array:
			if tile is Tile:
				tile.highlight_this_square_for_movement()
				tile.tile_is_available_for_movement = true
	
	for tile in board.get_children():
		if tile.name in occupied_but_available_tiles_array:
			if tile is Tile:
				tile.highlight_this_square_for_attack()
				tile.tile_is_available_for_movement = true
	
func unhighlight_all_squares() -> void:
	for tile in board.get_children():
		if tile is Tile:
			tile.unhighlight_this_square()
			tile.tile_is_available_for_movement = false

func is_valid(position: Vector2) -> bool:
	if position.x < 0 or position.y < 0:
		return false
	if position.x > 7 or position.y > 7:
		return false
	return true

func check_if_tile_is_occupied(matrix_representation: Vector2) -> bool:
	var tile_name = matrix_representation_to_tile_name(matrix_representation)
	var tile = null
	if board.has_node(tile_name):
		tile = board.get_node(tile_name)
	if is_valid(matrix_representation) and  tile.tile_is_occupied == true:
		return true
	else:
		return false
		
func tile_name_to_matrix_representation(tile_name: String) -> Vector2:
	var column_letter = tile_name[0]
	var row_number = tile_name[1].to_int() - 1
	
	var column_index = column_letter.unicode_at(0) - 'a'.unicode_at(0)
	
	return Vector2(row_number, column_index)
	
func matrix_representation_to_tile_name(matrix_representation: Vector2) -> String:
	var column_letter = char('a'.unicode_at(0) + int(matrix_representation.y))
	var row_number: int = matrix_representation.x + 1
	return column_letter + str(row_number)
