class_name Piece extends Node2D

@onready var piece_sprite = $piece

var color = ""
var this_piece = "king"

func set_piece_color(piece_color: String) -> void:
	color = piece_color
	set_piece_sprite(this_piece)
	
func set_piece_sprite(piece_name: String) -> void:
	this_piece = piece_name
	if color == "white":
		if piece_name == "king":
			piece_sprite.texture = load("res://sprites/chess_pieces/beli_kralj.png")
		if piece_name == "queen":
			piece_sprite.texture = load("res://sprites/chess_pieces/bela_kraljica.png")
		if piece_name == "knight":
			piece_sprite.texture = load("res://sprites/chess_pieces/beli_konj.png")
		if piece_name == "bishop":
			piece_sprite.texture = load("res://sprites/chess_pieces/beli_lovac.png")
		if piece_name == "rook":
			piece_sprite.texture = load("res://sprites/chess_pieces/beli_top.png")
		if piece_name == "pawn":
			piece_sprite.texture = load("res://sprites/chess_pieces/beli_piun.png")

	if color == "black":
		if piece_name == "king":
			piece_sprite.texture = load("res://sprites/chess_pieces/crni_kralj.png")
		if piece_name == "queen":
			piece_sprite.texture = load("res://sprites/chess_pieces/crna_kraljica.png")
		if piece_name == "knight":
			piece_sprite.texture = load("res://sprites/chess_pieces/crni_konj.png")
		if piece_name == "bishop":
			piece_sprite.texture = load("res://sprites/chess_pieces/crni_lovac.png")
		if piece_name == "rook":
			piece_sprite.texture = load("res://sprites/chess_pieces/crni_top.png")
		if piece_name == "pawn":
			piece_sprite.texture = load("res://sprites/chess_pieces/crni_piun.png")
	
	if color == "red":
		if piece_name == "king":
			piece_sprite.texture = load("res://sprites/chess_pieces/crveni_kralj.png")
		if piece_name == "queen":
			piece_sprite.texture = load("res://sprites/chess_pieces/crvena_kraljica.png")
		if piece_name == "knight":
			piece_sprite.texture = load("res://sprites/chess_pieces/crveni_konj.png")
		if piece_name == "bishop":
			piece_sprite.texture = load("res://sprites/chess_pieces/crveni_lovac.png")
		if piece_name == "rook":
			piece_sprite.texture = load("res://sprites/chess_pieces/crveni_top.png")
		if piece_name == "pawn":
			piece_sprite.texture = load("res://sprites/chess_pieces/crveni_piun.png")
	
	if color == "blue":
		if piece_name == "king":
			piece_sprite.texture = load("res://sprites/chess_pieces/plavi_kralj.png")
		if piece_name == "queen":
			piece_sprite.texture = load("res://sprites/chess_pieces/plava_kraljica.png")
		if piece_name == "knight":
			piece_sprite.texture = load("res://sprites/chess_pieces/plavi_konj.png")
		if piece_name == "bishop":
			piece_sprite.texture = load("res://sprites/chess_pieces/plavi_lovac.png")
		if piece_name == "rook":
			piece_sprite.texture = load("res://sprites/chess_pieces/plavi_top.png")
		if piece_name == "pawn":
			piece_sprite.texture = load("res://sprites/chess_pieces/plavi_piun.png")
