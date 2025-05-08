class_name Selection_window extends Node2D

@onready var pawn = $pieces/pawn
@onready var bishop = $pieces/bishop
@onready var knight = $pieces/knight
@onready var rook = $pieces/rook
@onready var queen =  $pieces/queen

@onready var underline_1 = $pieces/underline1
@onready var underline_2 = $pieces/underline2
@onready var underline_3 = $pieces/underline3
@onready var underline_4 = $pieces/underline4
@onready var underline_5 = $pieces/underline5
@onready var selection_animation_window = $SelectionAnimationWindow
@onready var pieces = $pieces

signal piece_chosen(piece_name: String)

var your_color = ""

func underline_this_piece_by_index(index: int) -> void:
	#selection_animation_window.start_animation(index)
	await get_tree().create_timer(1).timeout
	pieces.show()
	if index <= 7:
		underline_1.show()
	elif index <= 9:
		underline_2.show()
	elif index <= 11:
		underline_3.show()
	elif index <= 13:
		underline_4.show()
	elif index <= 14:
		underline_5.show()
	
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


func mandatory_roulette_animation() -> void:
	underline_1.show()
	await get_tree().create_timer(0.1).timeout
	underline_1.hide()
	underline_2.show()
	await get_tree().create_timer(0.1).timeout
	underline_2.hide()
	underline_3.show()
	await get_tree().create_timer(0.1).timeout
	underline_3.hide()
	underline_4.show()
	await get_tree().create_timer(0.1).timeout
	underline_4.hide()
	underline_5.show()
	await get_tree().create_timer(0.1).timeout
	underline_5.hide()
	underline_1.show()
	await get_tree().create_timer(0.2).timeout
	underline_1.hide()
	underline_2.show()
	await get_tree().create_timer(0.2).timeout
	underline_2.hide()
	underline_3.show()
	await get_tree().create_timer(0.2).timeout
	underline_3.hide()
	underline_4.show()
	await get_tree().create_timer(0.2).timeout
	underline_4.hide()
	underline_5.show()
	await get_tree().create_timer(0.2).timeout
	underline_5.hide()
	
func underline_this_piece(piece_name: String):
	await mandatory_roulette_animation()
	if piece_name == "pawn":
		underline_1.show()
	if piece_name == "bishop":
		underline_1.show()
		await get_tree().create_timer(0.25).timeout
		underline_1.hide()
		underline_2.show()
	if piece_name == "knight":
		underline_1.show()
		await get_tree().create_timer(0.25).timeout
		underline_1.hide()
		underline_2.show()
		await get_tree().create_timer(0.3).timeout
		underline_2.hide()
		underline_3.show()
	if piece_name == "rook":
		underline_1.show()
		await get_tree().create_timer(0.25).timeout
		underline_1.hide()
		underline_2.show()
		await get_tree().create_timer(0.3).timeout
		underline_2.hide()
		underline_3.show()
		await get_tree().create_timer(0.35).timeout
		underline_3.hide()
		underline_4.show()
	if piece_name == "queen":
		underline_1.show()
		await get_tree().create_timer(0.25).timeout
		underline_1.hide()
		underline_2.show()
		await get_tree().create_timer(0.3).timeout
		underline_2.hide()
		underline_3.show()
		await get_tree().create_timer(0.35).timeout
		underline_3.hide()
		underline_4.show()
		await get_tree().create_timer(0.4).timeout
		underline_4.hide()
		underline_5.show()
		
func underline_this_piece2(piece_name: String):
	underline_this_piece(piece_name)
	if piece_name == "pawn":
		underline_1.show()
	if piece_name == "bishop":
		underline_2.show()
	if piece_name == "knight":
		underline_3.show()
	if piece_name == "rook":
		underline_4.show()
	if piece_name == "queen":
		underline_5.show()

func remove_underline() -> void:
	underline_1.hide()
	underline_2.hide()
	underline_3.hide()
	underline_4.hide()
	underline_5.hide()
