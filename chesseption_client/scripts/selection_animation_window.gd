class_name Selection_animation_window extends Node2D

@onready var pawn_1 = $pieces/BeliPiun
@onready var pawn_2 = $pieces/BeliPiun2
@onready var pawn_3 = $pieces/BeliPiun3
@onready var pawn_4 = $pieces/BeliPiun4
@onready var pawn_5 = $pieces/BeliPiun5
@onready var pawn_6 = $pieces/BeliPiun6
@onready var pawn_7 = $pieces/BeliPiun7
@onready var pawn_8 = $pieces/BeliPiun8
@onready var bishop_1 = $pieces/BeliLovac
@onready var bishop_2 = $pieces/BeliLovac2
@onready var knight_1 = $pieces/BeliKonj
@onready var knight_2 = $pieces/BeliKonj2
@onready var rook_1 = $pieces/BeliTop
@onready var rook_2 = $pieces/BeliTop2
@onready var queen_2 = $pieces/BelaKraljica

@onready var pieces = $pieces

func start_animation(chosen_piece: int) -> void:
	for piece in pieces.get_children():
		highlight(piece)
		await get_tree().create_timer(0.04).timeout
		unhighlight(piece)
	
	for piece in pieces.get_children():
		highlight(piece)
		await get_tree().create_timer(0.04).timeout
		unhighlight(piece)
	
	for piece in pieces.get_children():
		highlight(piece)
		await get_tree().create_timer(0.04).timeout
		unhighlight(piece)
	var i = 0
	for piece in pieces.get_children():
		highlight(piece)
		await get_tree().create_timer(0.04).timeout
		if i == chosen_piece:
			break
		else:
			i += 1
			unhighlight(piece)
	
func highlight(piece: Sprite2D) -> void:
	piece.modulate = Color(1.5, 1.5, 1.5, 1)
	piece.z_index = 10
	
func unhighlight(piece: Sprite2D) -> void:
	piece.modulate = Color(1, 1, 1, 1)
	piece.z_index = 0
