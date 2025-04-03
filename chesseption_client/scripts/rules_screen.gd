class_name Rules_screen extends Node2D

@onready var back_button = $Back_button

signal back_to_options_screen()

func _on_back_button_pressed() -> void:
	emit_signal("back_to_options_screen")

func _on_back_button_mouse_entered() -> void:
	back_button.scale.x += 0.08
	back_button.scale.y += 0.08
	back_button.position.x -= 10



func _on_back_button_mouse_exited() -> void:
	back_button.scale.x -= 0.08
	back_button.scale.y -= 0.08
	back_button.position.x += 10
