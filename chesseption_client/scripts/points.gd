class_name Points extends Node2D

@onready var white_points_label = $white_points_label
@onready var black_points_label = $black_points_label
@onready var red_points_label = $red_points_label
@onready var blue_points_label = $blue_points_label

func update_points() -> void:
	white_points_label.set_text(str(GameState.points[0]))
	black_points_label.set_text(str(GameState.points[1]))
	if GameState.game_type >= 3:
		red_points_label.show()
		red_points_label.set_text(str(GameState.points[2]))
	if GameState.game_type == 4:
		blue_points_label.show()
		blue_points_label.set_text(str(GameState.points[3]))
