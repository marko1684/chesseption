class_name Main_menu extends Node2D

@onready var play_button = $PlayButton
@onready var view_profile_button = $ProfileButton

signal play_button_pressed()

func _on_play_button_mouse_entered() -> void:
	play_button.scale.x += 0.08
	play_button.scale.y += 0.08
	play_button.position.x -= 10

func _on_play_button_mouse_exited() -> void:
	play_button.scale.x -= 0.08
	play_button.scale.y -= 0.08
	play_button.position.x += 10

func _on_play_button_pressed() -> void:
	emit_signal("play_button_pressed")


func _on_profile_button_mouse_entered() -> void:
	view_profile_button.scale.x += 0.08
	view_profile_button.scale.y += 0.08
	view_profile_button.position.x -= 10


func _on_profile_button_mouse_exited() -> void:
	view_profile_button.scale.x -= 0.08
	view_profile_button.scale.y -= 0.08
	view_profile_button.position.x += 10

func _on_profile_button_pressed() -> void:
	emit_signal("view_profile_button_pressed")
