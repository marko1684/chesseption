class_name Game extends Node2D

@onready var board = $Board
@onready var selection_window: Selection_window = $Selection_window

@onready var white_piece = $Pieces/White_piece
@onready var black_piece = $Pieces/Black_piece
@onready var red_piece = $Pieces/Red_piece
@onready var blue_piece = $Pieces/Blue_piece

var your_color = ""
var your_piece = ""
var your_king = null #the piece you will be controling
var your_king_position = ""

func _ready() -> void:
	white_piece.set_piece_color("white")
	black_piece.set_piece_color("black")
	red_piece.set_piece_color("red")
	blue_piece.set_piece_color("blue")
	
	for tile in board.get_children():
		if tile is Tile:
			tile.connect("piece_moved", Callable(self, "_on_piece_moved"))
			
	set_your_king()
	draw_board()
	
	draw_your_selection_window()

func _on_piece_moved(new_tile_name: String) -> void:
	#puff.position = Board.get_node(your_king.your_tile_name).global_position		
	#puff.animation.play("puff_animation")

	your_king_position = new_tile_name
	
	await get_tree().create_timer(0.6).timeout
	
	your_king.set_piece_sprite(your_piece)
	await get_tree().create_timer(0.15).timeout
	
	your_king.position = board.get_node(new_tile_name).global_position + Vector2(0, -10)
	
	#if underlined_piece_that_was_pulled_out_of_the_box == your_king.this_piece:
	#	MultiplayerManager.make_move(multiplayer.get_unique_id(), your_king.your_tile_name, your_king.this_piece, false)
	#else:
	#	MultiplayerManager.make_move(multiplayer.get_unique_id(), your_king.your_tile_name, your_king.this_piece, true)

	unhighlight_all_squares()
	#your_pieces.remove_underline()
	
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
	black_piece.global_position = board.black_piece_position.global_position + Vector2(0, -10)

func highlight_available_tiles() -> void:
	var available_tiles_array: Array = []
	var coord: Vector2 = tile_name_to_matrix_representation(your_king_position)
	if your_piece == "pawn":
		var new_coords = []
		if your_color == "white":
			new_coords.append(coord + Vector2(-1, 1))
			new_coords.append(coord + Vector2(0, 1))
			new_coords.append(coord + Vector2(1, 1))
		elif your_color == "black":
			new_coords.append(coord + Vector2(-1, -1))
			new_coords.append(coord + Vector2(0, -1))
			new_coords.append(coord + Vector2(1, -1))
		elif your_color == "red":
			new_coords.append(coord + Vector2(-1, -1))
			new_coords.append(coord + Vector2(-1, 0))
			new_coords.append(coord + Vector2(-1, 1))
		elif your_color == "blue":
			new_coords.append(coord + Vector2(1, -1))
			new_coords.append(coord + Vector2(1, 0))
			new_coords.append(coord + Vector2(1, 1))
		available_tiles_array = new_coords.filter(is_valid).map(matrix_representation_to_tile_name)
		
	
	if your_piece == "bishop":
		var new_coords = []
		for i in range(1,4):
			new_coords.append(coord + Vector2(i,i))
			new_coords.append(coord + Vector2(-i,i))
			new_coords.append(coord + Vector2(i,-i))
			new_coords.append(coord + Vector2(-i,-i))
		available_tiles_array = new_coords.filter(is_valid).map(matrix_representation_to_tile_name)
			
	if your_piece == "knight":
		your_piece = "knight"
		var new_coords = []
		new_coords.append(coord + Vector2(1,2))
		new_coords.append(coord + Vector2(1,-2))
		new_coords.append(coord + Vector2(-1,2))
		new_coords.append(coord + Vector2(-1,-2))
		new_coords.append(coord + Vector2(2,1))
		new_coords.append(coord + Vector2(2,-1))
		new_coords.append(coord + Vector2(-2,1))
		new_coords.append(coord + Vector2(-2,-1))
		available_tiles_array = new_coords.filter(is_valid).map(matrix_representation_to_tile_name)

		
	if your_piece == "rook":
		your_piece = "rook"
		var new_coords = []
		for i in range(1,4):
			new_coords.append(coord + Vector2(0,i))
			new_coords.append(coord + Vector2(0,-i))
			new_coords.append(coord + Vector2(i,0))
			new_coords.append(coord + Vector2(-i,0))
		available_tiles_array = new_coords.filter(is_valid).map(matrix_representation_to_tile_name)
	
	if your_piece == "queen":
		your_piece = "queen"
		var new_coords = []
		for i in range(1,5):
			new_coords.append(coord + Vector2(i,i))
			new_coords.append(coord + Vector2(-i,i))
			new_coords.append(coord + Vector2(i,-i))
			new_coords.append(coord + Vector2(-i,-i))
			new_coords.append(coord + Vector2(0,i))
			new_coords.append(coord + Vector2(0,-i))
			new_coords.append(coord + Vector2(i,0))
			new_coords.append(coord + Vector2(-i,0))
		available_tiles_array = new_coords.filter(is_valid).map(matrix_representation_to_tile_name)
		
	for tile in board.get_children():
		if tile.name in available_tiles_array:
			if tile is Tile:
				tile.highlight_this_square_for_movement()
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
	
func tile_name_to_matrix_representation(tile_name: String) -> Vector2:
	var column_letter = tile_name[0]
	var row_number = tile_name[1].to_int() - 1
	
	var column_index = column_letter.unicode_at(0) - 'a'.unicode_at(0)
	
	return Vector2(row_number, column_index)
	
func matrix_representation_to_tile_name(matrix_representation: Vector2) -> String:
	var column_letter = char('a'.unicode_at(0) + int(matrix_representation.y))
	var row_number: int = matrix_representation.x + 1
	return column_letter + str(row_number)
