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

var you_clicked_challange_or_accept_button = false
var your_color = ""
var your_piece = ""
var your_king = null #the piece you will be controling
var your_king_position = ""
var drawn_piece = ""
func _ready() -> void:
	
	challange_window.connect("move_challanged", Callable(self, ("_on_move_challanged")))
	challange_window.connect("move_accepted", Callable(self, ("_on_move_accepted")))
	diamond.animation.play("diamond_animation")

	for tile in board.tiles.get_children():
		if tile is Tile:
			tile.connect("piece_moved", Callable(self, "_on_piece_moved"))
			

func setup_game() -> void:
	white_piece.set_piece_color("white")
	black_piece.set_piece_color("black")
	if GameState.game_type == 3:
		red_piece.set_piece_color("red")
	elif GameState.game_type == 4:
		red_piece.set_piece_color("red")
		blue_piece.set_piece_color("blue")
	GameState.turn_player = GameState.all_players_names[0]
	board.diamond_position = board.find_tile_by_name(GameState.diamond_position)
	
	set_your_king()
	determine_your_state()

func set_your_king() -> void:
	your_piece = "king"
	if GameState.all_players_names[0] == GameState.your_username:
		your_color = "white"
		your_king = white_piece
		your_king_position = board.white_piece_position.name
	elif GameState.all_players_names[1] == GameState.your_username:
		your_color = "black"
		your_king = black_piece
		your_king_position = board.black_piece_position.name
	elif GameState.all_players_names[2] == GameState.your_username:
		your_color = "red"
		your_king = red_piece
		your_king_position = board.red_piece_position.name
	elif GameState.all_players_names[3] == GameState.your_username:
		your_color = "blue"
		your_king = blue_piece
		your_king_position = board.blue_piece_position.name

func _on_move_accepted() -> void:
	you_clicked_challange_or_accept_button = true
	challange_window.hide()
	var data = {
		"game_id": GameState.lobby_id,
		"player_id": GameState.your_username,
	}
	var json_data = JSON.stringify(data)
	var headers = ["Content-Type: application/json"]
	
	$HTTPRequest_make_move.request(
		GameState.server_address + "/game/accept_move",
		headers,
		HTTPClient.METHOD_POST,
		json_data
	)
func _on_move_challanged() -> void:
	you_clicked_challange_or_accept_button = true
	challange_window.hide()
	var data = {
		"game_id": GameState.lobby_id,
		"player1_id": GameState.your_username,
		"player2_id": GameState.last_player
	}
	var json_data = JSON.stringify(data)
	var headers = ["Content-Type: application/json"]
	
	$HTTPRequest_make_move.request(
		GameState.server_address + "/game/challenge_move",
		headers,
		HTTPClient.METHOD_POST,
		json_data
	)
	#either calculate new board state based of player lied or diidnt and send it to server, 
	#or just send it to the server and let it calcualte new board state.
	#Either way server sends new board state to every player with message playerX challanged playerY and playerY lied/diidnt lie
func _on_http_request_move_challanged_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	var response = body.get_string_from_utf8()
	if response == "-1":
		await get_tree().create_timer(1).timeout
		get_game_state()
	else:
		print(response)
		save_response_data_in_game_state(body)
		determine_your_state()
func _on_http_request_move_accepted_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	var response = body.get_string_from_utf8()
	if response == "-1":
		await get_tree().create_timer(1).timeout
		get_game_state()
	else:
		print(response)
		save_response_data_in_game_state(body)
		determine_your_state()


func update_board() -> void:
	board.free_all_occupied_tiles()
	board.diamond_position = board.find_tile_by_name(GameState.diamond_position)
	update_white_piece_figure_and_position()
	update_black_piece_figure_and_position()
	if GameState.game_type == 3:
		update_red_piece_figure_and_position()
	elif GameState.game_type == 4:
		update_red_piece_figure_and_position()
		update_blue_piece_figure_and_position()
	
	if your_color == "white":
		your_king_position = board.white_piece_position.name
	elif your_color == "black":
		your_king_position = board.black_piece_position.name
	elif your_color == "red":
		your_king_position = board.red_piece_position.name
	elif your_color == "blue":
		your_king_position = board.blue_piece_position.name
		
	draw_board()
	
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

func _on_piece_moved(new_tile_name: String) -> void:
	selection_window.hide()
	puff.position = board.tiles.get_node(NodePath(your_king_position)).global_position
	puff.animation.play("puff_animation")
	
	if board.tiles.has_node(NodePath(your_king_position)):
		board.tiles.get_node(NodePath(your_king_position)).tile_is_occupied = false
	your_king_position = new_tile_name
	await get_tree().create_timer(0.6).timeout
	your_king.set_piece_sprite(your_piece)
	await get_tree().create_timer(0.15).timeout
	if check_if_tile_is_occupied(tile_name_to_matrix_representation(new_tile_name)):
		remove_piece_from_this_tile(new_tile_name)
	
	your_king.position = board.tiles.get_node(new_tile_name).global_position + Vector2(0, -10)
	board.tiles.get_node(new_tile_name).tile_is_occupied = true
	
	if your_color == "white":
		board.white_piece_position = board.tiles.get_node(NodePath(your_king_position))
	if your_color == "black":
		board.black_piece_position = board.tiles.get_node(NodePath(your_king_position))
	if your_color == "red":
		board.red_piece_position = board.tiles.get_node(NodePath(your_king_position))
	if your_color == "blue":
		board.blue_piece_position = board.tiles.get_node(NodePath(your_king_position))
	
	update_gamestate()
	unhighlight_all_squares()
	selection_window.remove_underline()
	make_move() #TODO remove eaten pieces from the board
	
func remove_piece_from_this_tile(new_tile_name: String) -> void:
	if board.white_piece_position.name == new_tile_name:
		board.white_piece_position = board.removed_pieces
		white_piece.position = board.removed_pieces.global_position 
		board.white_piece_position = return_random_unoccupied_tile("white")
		board.white_piece_position.tile_is_occupied = true
	if board.black_piece_position.name == new_tile_name:
		board.black_piece_position = board.removed_pieces
		black_piece.position = board.removed_pieces.global_position 
		board.black_piece_position = return_random_unoccupied_tile("black")
		board.black_piece_position.tile_is_occupied = true
	if board.red_piece_position.name == new_tile_name:
		board.red_piece_position = board.removed_pieces
		red_piece.position = board.removed_pieces.global_position 
		board.red_piece_position = return_random_unoccupied_tile("red")
		board.red_piece_position.tile_is_occupied = true
	if board.blue_piece_position.name == new_tile_name:
		board.blue_piece_position = board.removed_pieces
		blue_piece.position = board.removed_pieces.global_position 
		board.blue_piece_position = return_random_unoccupied_tile("blue")
		board.blue_piece_position.tile_is_occupied = true
	if board.diamond_position.name == new_tile_name:
		
		#board.diamond_position = board.removed_pieces
		#diamond.position = board.removed_pieces.global_position
		place_diamond_to_a_random_tile()

func place_diamond_to_a_random_tile() -> void:
	var new_tile = null
	var random_tile_number = 0
	if GameState.game_type == 2:
		random_tile_number = randi_range(0, 60)
	if GameState.game_type == 3:
		random_tile_number = randi_range(0, 59)
	if GameState.game_type == 4:
		random_tile_number = randi_range(0, 58)
		
	var i = 0
	for tile in board.tiles.get_children():
		if tile.tile_is_occupied == false:
			if i == random_tile_number:
				board.diamond_position = tile
				diamond.position = board.diamond_position.global_position
				GameState.diamond_position = board.diamond_position.name
			i += 1
			
func draw_your_selection_window() -> void:
	selection_window.set_your_color(your_color)
	if not selection_window.is_connected("piece_chosen", Callable(self, "_on_piece_chosen")):
		selection_window.connect("piece_chosen", Callable(self, "_on_piece_chosen"))
	selection_window.show()
	
func _on_piece_chosen(piece_name: String) -> void:
	if your_piece != "king":
		unhighlight_all_squares()

	your_piece = piece_name
	highlight_available_tiles()
		
func draw_board() -> void:
	white_piece.position = board.white_piece_position.global_position + Vector2(0, -10)
	board.white_piece_position.tile_is_occupied = true
	white_piece.set_piece_sprite(white_piece.this_piece)
	black_piece.position = board.black_piece_position.global_position + Vector2(0, -10)
	board.black_piece_position.tile_is_occupied = true
	black_piece.set_piece_sprite(black_piece.this_piece)

	diamond.position = board.diamond_position.global_position + Vector2(0, 0)
	board.diamond_position.tile_is_occupied = true

	if GameState.game_type == 3 and board.red_piece_position != null:
		red_piece.position = board.red_piece_position.global_position + Vector2(0, -10)
		board.red_piece_position.tile_is_occupied = true
		red_piece.set_piece_sprite(red_piece.this_piece)

	elif GameState.game_type == 4 and board.blue_piece_position != null:
		red_piece.position = board.red_piece_position.global_position + Vector2(0, -10)
		board.red_piece_position.tile_is_occupied = true
		red_piece.set_piece_sprite(red_piece.this_piece)
		blue_piece.position = board.blue_piece_position.global_position + Vector2(0, -10)
		board.blue_piece_position.tile_is_occupied = true
		blue_piece.set_piece_sprite(blue_piece.this_piece)

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
		
	for tile in board.tiles.get_children():
		if tile.name in available_tiles_array:
			if tile is Tile:
				tile.highlight_this_square_for_movement()
				tile.tile_is_available_for_movement = true
				
				
	for tile in board.tiles.get_children():
		if tile.name in occupied_but_available_tiles_array:
			if tile is Tile:
				tile.highlight_this_square_for_attack()
				tile.tile_is_available_for_movement = true
	
func unhighlight_all_squares() -> void:
	for tile in board.tiles.get_children():
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
	if board.tiles.has_node(tile_name):
		tile = board.tiles.get_node(tile_name)
	if is_valid(matrix_representation) and tile != null and tile.tile_is_occupied == true:
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

func update_gamestate() -> void:
	var white_piece_name = ""
	if white_piece.this_piece == "king":
		white_piece_name = "k"
	elif white_piece.this_piece == "pawn":
		white_piece_name = "p"
	elif white_piece.this_piece == "bishop":
		white_piece_name = "b"
	elif white_piece.this_piece == "knight":
		white_piece_name = "h"
	elif white_piece.this_piece == "rook":
		white_piece_name = "r"
	elif white_piece.this_piece == "queen":
		white_piece_name = "q"
	if board.white_piece_position.name == "Removed_pieces":
		GameState.pieces_positions[0]= "xx" + white_piece_name
	else:
		GameState.pieces_positions[0]= board.white_piece_position.name + white_piece_name

	var black_piece_name = ""
	if black_piece.this_piece == "king":
		black_piece_name = "k"
	elif black_piece.this_piece == "pawn":
		black_piece_name = "p"
	elif black_piece.this_piece == "bishop":
		black_piece_name = "b"
	elif black_piece.this_piece == "knight":
		black_piece_name = "h"
	elif black_piece.this_piece == "rook":
		black_piece_name = "r"
	elif black_piece.this_piece == "queen":
		black_piece_name = "q"
	if board.black_piece_position.name == "Removed_pieces":
		GameState.pieces_positions[1]= "xx" + black_piece_name
	else:
		GameState.pieces_positions[1]= board.black_piece_position.name + black_piece_name

	
	if GameState.game_type == 3:
		var red_piece_name = ""
		if red_piece.this_piece == "king":
			red_piece_name = "k"
		elif red_piece.this_piece == "pawn":
			red_piece_name = "p"
		elif red_piece.this_piece == "bishop":
			red_piece_name = "b"
		elif red_piece.this_piece == "knight":
			red_piece_name = "h"
		elif red_piece.this_piece == "rook":
			red_piece_name = "r"
		elif red_piece.this_piece == "queen":
			red_piece_name = "q"
		if board.red_piece_position.name == "Removed_pieces":
			GameState.pieces_positions[2]= "xx" + red_piece_name
		else:
			GameState.pieces_positions[2]= board.red_piece_position.name + red_piece_name
		
	if GameState.game_type == 4:
		var blue_piece_name = ""
		if blue_piece.this_piece == "king":
			blue_piece_name = "k"
		elif blue_piece.this_piece == "pawn":
			blue_piece_name = "p"
		elif blue_piece.this_piece == "bishop":
			blue_piece_name = "b"
		elif blue_piece.this_piece == "knight":
			blue_piece_name = "h"
		elif blue_piece.this_piece == "rook":
			blue_piece_name = "r"
		elif blue_piece.this_piece == "queen":
			blue_piece_name = "q"
		if board.blue_piece_position.name == "Removed_pieces":
			GameState.pieces_positions[3]= "xx" + blue_piece_name
		else:
			GameState.pieces_positions[3]= board.blue_piece_position.name + blue_piece_name
		
	GameState.diamond_position = board.diamond_position.name
	if your_piece == drawn_piece:
		GameState.lied = false
	else:
		GameState.lied = true
	

func update_white_piece_figure_and_position() -> void:
		var full_str = GameState.pieces_positions[0]
		var white_piece_position = full_str.substr(0, full_str.length() - 1)
		var white_piece_name = full_str[-1]
		board.white_piece_position = board.find_tile_by_name(white_piece_position)
		if white_piece_name == "k":
			white_piece.this_piece = "king"
		elif white_piece_name == "p":
			white_piece.this_piece = "pawn"
		elif white_piece_name == "b":
			white_piece.this_piece = "bishop"
		elif white_piece_name == "h":
			white_piece.this_piece = "knight"
		elif white_piece_name == "r":
			white_piece.this_piece = "rook"
		elif white_piece_name == "q":
			white_piece.this_piece = "queen"
func update_black_piece_figure_and_position() -> void:
		var full_str = GameState.pieces_positions[1]
		var black_piece_position = full_str.substr(0, full_str.length() - 1)
		var black_piece_name = full_str[-1]
		board.black_piece_position = board.find_tile_by_name(black_piece_position)
		if black_piece_name == "k":
			black_piece.this_piece = "king"
		elif black_piece_name == "p":
			black_piece.this_piece = "pawn"
		elif black_piece_name == "b":
			black_piece.this_piece = "bishop"
		elif black_piece_name == "h":
			black_piece.this_piece = "knight"
		elif black_piece_name == "r":
			black_piece.this_piece = "rook"
		elif black_piece_name == "q":
			black_piece.this_piece = "queen"
func update_red_piece_figure_and_position() -> void:
		var full_str = GameState.pieces_positions[2]
		var red_piece_position = full_str.substr(0, full_str.length() - 1)
		var red_piece_name = full_str[-1]
		board.red_piece_position = board.find_tile_by_name(red_piece_position)
		if red_piece_name == "k":
			red_piece.this_piece = "king"
		elif red_piece_name == "p":
			red_piece.this_piece = "pawn"
		elif red_piece_name == "b":
			red_piece.this_piece = "bishop"
		elif red_piece_name == "h":
			red_piece.this_piece = "knight"
		elif red_piece_name == "r":
			red_piece.this_piece = "rook"
		elif red_piece_name == "q":
			red_piece.this_piece = "queen"
func update_blue_piece_figure_and_position() -> void:
		var full_str = GameState.pieces_positions[3]
		var blue_piece_position = full_str.substr(0, full_str.length() - 1)
		var blue_piece_name = full_str[-1]
		board.blue_piece_position = board.find_tile_by_name(blue_piece_position)
		if blue_piece_name == "k":
			blue_piece.this_piece = "king"
		elif blue_piece_name == "p":
			blue_piece.this_piece = "pawn"
		elif blue_piece_name == "b":
			blue_piece.this_piece = "bishop"
		elif blue_piece_name == "h":
			blue_piece.this_piece = "knight"
		elif blue_piece_name == "r":
			blue_piece.this_piece = "rook"
		elif blue_piece_name == "q":
			blue_piece.this_piece = "queen"

func make_move() -> void:
	var data
	if GameState.game_type == 2:
		data = {
				"game_id": GameState.lobby_id,
				"player_id": GameState.your_username,
				"lied": GameState.lied,
				"new_board_state": {
					"player_positions": {
					GameState.all_players_names[0]: {
						"position": GameState.pieces_positions[0],
						"points": int(GameState.pieces_positions[0])
				},
					GameState.all_players_names[1]: {
						"position": GameState.pieces_positions[1],
						"points": int(GameState.pieces_positions[1])
				}
				},
					"diamond_position": GameState.diamond_position
				}
			}
	elif GameState.game_type == 3:
		data = {
				"game_id": GameState.lobby_id,
				"player_id": GameState.your_username,
				"lied": GameState.lied,
				"new_board_state": {
					"player_positions": {
					GameState.all_players_names[0]: {
						"position": GameState.pieces_positions[0],
						"points": int(GameState.pieces_positions[0])
				},
					GameState.all_players_names[1]: {
						"position": GameState.pieces_positions[1],
						"points": int(GameState.pieces_positions[1])
				},
				GameState.all_players_names[2]: {
						"position": GameState.pieces_positions[2],
						"points": int(GameState.pieces_positions[2])
				}
				},
					"diamond_position": GameState.diamond_position
				}
			}
	elif GameState.game_type == 4:
		data = {
				"game_id": GameState.lobby_id,
				"player_id": GameState.your_username,
				"lied": GameState.lied,
				"new_board_state": {
					"player_positions": {
					GameState.all_players_names[0]: {
						"position": GameState.pieces_positions[0],
						"points": int(GameState.pieces_positions[0])
				},
					GameState.all_players_names[1]: {
						"position": GameState.pieces_positions[1],
						"points": int(GameState.pieces_positions[1])
				},
				GameState.all_players_names[2]: {
						"position": GameState.pieces_positions[2],
						"points": int(GameState.pieces_positions[2])
				},
				GameState.all_players_names[3]: {
						"position": GameState.pieces_positions[3],
						"points": int(GameState.pieces_positions[3])
				}
				},
					"diamond_position": GameState.diamond_position
				}
			}
	var json_data = JSON.stringify(data)
	var headers = ["Content-Type: application/json"]
	
	$HTTPRequest_make_move.request(
		GameState.server_address + "/game/make_move",
		headers,
		HTTPClient.METHOD_POST,
		json_data
	)
	
func _on_http_request_make_move_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	var response = body.get_string_from_utf8()
	if response == "-1":
		await get_tree().create_timer(1).timeout
		get_game_state()
	else:
		print(response)
		save_response_data_in_game_state(body)
		determine_your_state()

func get_game_state() -> void:
	var headers = ["Content-Type: application/json"]
	
	$HTTPRequest_get_game_state.request(
		GameState.server_address + "/game/state/" + GameState.lobby_id,
		headers,
		HTTPClient.METHOD_GET
	)

func _on_http_request_get_game_state_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	var response = body.get_string_from_utf8()
	if response == "-1":
		await get_tree().create_timer(2).timeout
		get_game_state()
		print("Awaiting new game state.")
	else:
		print(response)
		save_response_data_in_game_state(body)
		determine_your_state()

func save_response_data_in_game_state(body: PackedByteArray) -> void:
	var response = body.get_string_from_utf8()
	var json = JSON.new()
	var error = json.parse(response)

	if error == OK:
		var data = json.get_data()
		var players = data["players"]
		var board_state = data["board_state"]
		var player_positions = board_state["player_positions"]
		
		GameState.turn_player = data["next_player"]
		if data["player_id"] == '123':
			GameState.last_player = GameState.turn_player
		else:
			GameState.last_player = data["player_id"]
		
		GameState.accepted_array = data["accepted"]
		GameState.all_players_names = []
		GameState.pieces_positions = []

		for player in players:
			if "player_id" in player:
				var player_name = player["player_id"]
				GameState.all_players_names.append(player_name)

				if player_name in player_positions:
					var pos_data = player_positions[player_name]
					if "position" in pos_data:
						GameState.pieces_positions.append(pos_data["position"])
					if "points" in pos_data:
						GameState.points.append(pos_data["points"])

		if "diamond_position" in board_state:
			GameState.diamond_position = board_state["diamond_position"]

func determine_your_state() -> void:
	update_board()
	print("Last player: " + GameState.last_player)
	print("Turn player: " + GameState.turn_player)
	var your_state = ""
	
	for number in GameState.accepted_array:
		if number["accept"] == 1:
			your_state = "challange"
			break

	if your_state == "challange":
		if GameState.last_player != GameState.your_username:
			challange_last_move()
		else:
			your_state = ""
			you_clicked_challange_or_accept_button = false
	if your_state != "challange":
		you_clicked_challange_or_accept_button = false
		if GameState.turn_player == GameState.your_username:
			your_turn()
		else:
			wait_for_other_players()

	update_board()
	
func wait_for_other_players() -> void:
	selection_window.hide()
	challange_window.hide()
	get_game_state()
	
func challange_last_move() -> void:
	if you_clicked_challange_or_accept_button == false:
		selection_window.hide()
		challange_window.show()
	get_game_state()
	
func your_turn() -> void:
	challange_window.hide()
	draw_your_selection_window()
	drawn_piece = get_random_piece_from_the_box(box) #the box will be assigned by the server
	selection_window.underline_this_piece(drawn_piece)

func return_random_unoccupied_tile_2() -> Tile:
	var empty_tiles = []

	for tile in board.tiles.get_children():
		if tile is Tile and not tile.tile_is_occupied: 
			empty_tiles.append(tile)

	if empty_tiles.size() > 0:
		var random_tile = empty_tiles[randi() % empty_tiles.size()]
		return board.tiles.get_node(NodePath(random_tile.name))
		print(random_tile.name)
		update_board()
	else:
		return null

func return_random_unoccupied_tile(piece_color: String) -> Tile:
	var candidate_tiles: Array = []
	
	for tile in board.tiles.get_children():
		var name_str = str(tile.name)
		match piece_color:
			"white":
				if name_str[0] == "a" and not tile.tile_is_occupied:
					candidate_tiles.append(tile)
			"black":
				if name_str[0] == "h" and not tile.tile_is_occupied:
					candidate_tiles.append(tile)
			"red":
				if name_str.substr(1).to_int() == 1 and not tile.tile_is_occupied:
					candidate_tiles.append(tile)
			"blue":
				if name_str.substr(1).to_int() == 8 and not tile.tile_is_occupied:
					candidate_tiles.append(tile)
	
	if candidate_tiles.size() > 0:
		return candidate_tiles.pick_random()
	else:
		return null
