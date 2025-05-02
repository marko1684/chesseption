class_name End_game_screen extends Node2D

@onready var back_to_main_menu_button = $back_to_main_menu

signal back_to_main_menu()

func _on_back_to_main_menu_pressed() -> void:
	emit_signal("back_to_main_menu")

func _on_back_to_main_menu_mouse_entered() -> void:
	back_to_main_menu_button.scale.x += 0.08
	back_to_main_menu_button.scale.y += 0.08
	back_to_main_menu_button.position.x -= 10
func _on_back_to_main_menu_mouse_exited() -> void:
	back_to_main_menu_button.scale.x -= 0.08
	back_to_main_menu_button.scale.y -= 0.08
	back_to_main_menu_button.position.x += 10
