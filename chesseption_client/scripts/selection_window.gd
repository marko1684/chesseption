class_name Selection_window extends Node2D

@onready var pawn = $pawn
@onready var bishop = $bishop
@onready var knight = $knight
@onready var rook = $rook
@onready var queen =  $queen
signal piece_chosen(piece_name: String)

var your_color = ""

func _on_pawn_pressed() -> void:
	emit_signal("piece_chosen", "pawn")
func _on_bishop_pressed() -> void:
	emit_signal("piece_chosen", "bishop")
func _on_knight_pressed() -> void:
	emit_signal("piece_chosen", "knight")
func _on_rook_pressed() -> void:
	emit_signal("piece_chosen", "rook")
func _on_queen_pressed() -> void:
	emit_signal("piece_chosen", "queen")


func set_your_color(color: String) -> void:
	your_color = color
	set_selection_pices_color_to_your_color()
	
func set_selection_pices_color_to_your_color() -> void:
	if your_color == "white":
		pawn.icon = load("res://sprites/chess_pieces/beli_piun.png")
		bishop.icon = load("res://sprites/chess_pieces/beli_lovac.png")
		knight.icon = load("res://sprites/chess_pieces/beli_konj.png")
		rook.icon = load("res://sprites/chess_pieces/beli_top.png")
		queen.icon = load("res://sprites/chess_pieces/bela_kraljica.png")
	elif your_color == "black":
		pawn.icon = load("res://sprites/chess_pieces/crni_piun.png")
		bishop.icon = load("res://sprites/chess_pieces/crni_lovac.png")
		knight.icon = load("res://sprites/chess_pieces/crni_konj.png")
		rook.icon = load("res://sprites/chess_pieces/crni_top.png")
		queen.icon = load("res://sprites/chess_pieces/crna_kraljica.png")
	elif your_color == "red":
		pawn.icon = load("res://sprites/chess_pieces/crveni_piun.png")
		bishop.icon = load("res://sprites/chess_pieces/crveni_lovac.png")
		knight.icon = load("res://sprites/chess_pieces/crveni_konj.png")
		rook.icon = load("res://sprites/chess_pieces/crveni_top.png")
		queen.icon = load("res://sprites/chess_pieces/crvena_kraljica.png")
	elif your_color == "blue":
		pawn.icon = load("res://sprites/chess_pieces/plavi_piun.png")
		bishop.icon = load("res://sprites/chess_pieces/plavi_lovac.png")
		knight.icon = load("res://sprites/chess_pieces/plavi_konj.png")
		rook.icon = load("res://sprites/chess_pieces/plavi_top.png")
		queen.icon = load("res://sprites/chess_pieces/plava_kraljica.png")
