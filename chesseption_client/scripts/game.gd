class_name Game extends Node2D

@onready var board = $Board

@onready var white_piece = $Pieces/White_piece
@onready var black_piece = $Pieces/Black_piece
@onready var red_piece = $Pieces/Red_piece
@onready var blue_piece = $Pieces/Blue_piece

var your_king = null
var your_color = "white"

func _ready() -> void:
	white_piece.set_piece_color("white")
	black_piece.set_piece_color("black")
	red_piece.set_piece_color("red")
	blue_piece.set_piece_color("blue")
	
	set_your_king()
	draw_board()
	
func set_your_king() -> void:
	your_king = white_piece
	
func draw_board() -> void:
	your_king.global_position = board.a5.global_position + Vector2(0, -10)
	black_piece.global_position = board.h5.global_position + Vector2(0, -10)
	
