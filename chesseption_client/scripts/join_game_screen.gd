class_name Join_game_screen extends Node2D

@onready var join_two_player_button = $JoinTwoPlayerGame
@onready var join_three_player_button = $JoinThreePlayerGame
@onready var join_four_player_button = $JoinFourPlayerGame
@onready var create_custom_game_button = $CreateCustomGame
@onready var back_to_main_menu_button = $back_to_main_menu

@onready var waiting_for_players_label = $Waiting_for_players_label

signal join_2_player_game()
signal join_3_player_game()
signal join_4_player_game()
signal create_custom_game()
signal back_to_main_menu()

func _on_join_two_player_game_mouse_entered() -> void:
	join_two_player_button.scale.x += 0.08
	join_two_player_button.scale.y += 0.08
	join_two_player_button.position.x -= 10
func _on_join_two_player_game_mouse_exited() -> void:
	join_two_player_button.scale.x -= 0.08
	join_two_player_button.scale.y -= 0.08
	join_two_player_button.position.x += 10

func _on_join_three_player_game_mouse_entered() -> void:
	join_three_player_button.scale.x += 0.08
	join_three_player_button.scale.y += 0.08
	join_three_player_button.position.x -= 10
func _on_join_three_player_game_mouse_exited() -> void:
	join_three_player_button.scale.x -= 0.08
	join_three_player_button.scale.y -= 0.08
	join_three_player_button.position.x += 10


func _on_join_four_player_game_mouse_entered() -> void:
	join_four_player_button.scale.x += 0.08
	join_four_player_button.scale.y += 0.08
	join_four_player_button.position.x -= 10
func _on_join_four_player_game_mouse_exited() -> void:
	join_four_player_button.scale.x -= 0.08
	join_four_player_button.scale.y -= 0.08
	join_four_player_button.position.x += 10

func _on_create_custom_game_mouse_entered() -> void:
	create_custom_game_button.scale.x += 0.08
	create_custom_game_button.scale.y += 0.08
	create_custom_game_button.position.x -= 10
func _on_create_custom_game_mouse_exited() -> void:
	create_custom_game_button.scale.x -= 0.08
	create_custom_game_button.scale.y -= 0.08
	create_custom_game_button.position.x += 10

func _on_back_to_main_menu_mouse_entered() -> void:
	back_to_main_menu_button.scale.x += 0.08
	back_to_main_menu_button.scale.y += 0.08
	back_to_main_menu_button.position.x -= 10
func _on_back_to_main_menu_mouse_exited() -> void:
	back_to_main_menu_button.scale.x -= 0.08
	back_to_main_menu_button.scale.y -= 0.08
	back_to_main_menu_button.position.x += 10

func _on_join_two_player_game_pressed() -> void:
	emit_signal("join_2_player_game")

func _on_join_three_player_game_pressed() -> void:
	emit_signal("join_3_player_game")

func _on_join_four_player_game_pressed() -> void:
	emit_signal("join_4_player_game")

func _on_create_custom_game_pressed() -> void:
	emit_signal("create_custom_game")
	
func _on_back_to_main_menu_pressed() -> void:
	emit_signal("back_to_main_menu")
