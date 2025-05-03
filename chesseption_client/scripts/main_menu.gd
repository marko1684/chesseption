class_name Main_menu extends Node2D

@onready var play_button = $PlayButton
@onready var view_profile_button = $ProfileButton
@onready var options_button = $Options
@onready var selection_animation = $SelectionAnimationWindow

signal play_button_pressed()
signal view_profile_button_pressed()
signal options_button_pressed()


func _on_play_button_pressed() -> void:
	emit_signal("play_button_pressed")
	
func _on_profile_button_pressed() -> void:
	emit_signal("view_profile_button_pressed")

func _on_options_pressed() -> void:
	emit_signal("options_button_pressed")
	
func _on_play_button_mouse_entered() -> void:
	play_button.scale.x += 0.08
	play_button.scale.y += 0.08
	play_button.position.x -= 10

func _on_play_button_mouse_exited() -> void:
	play_button.scale.x -= 0.08
	play_button.scale.y -= 0.08
	play_button.position.x += 10

func _on_profile_button_mouse_entered() -> void:
	view_profile_button.scale.x += 0.08
	view_profile_button.scale.y += 0.08
	view_profile_button.position.x -= 10


func _on_profile_button_mouse_exited() -> void:
	view_profile_button.scale.x -= 0.08
	view_profile_button.scale.y -= 0.08
	view_profile_button.position.x += 10

func _on_options_mouse_entered() -> void:
	options_button.scale.x += 0.08
	options_button.scale.y += 0.08
	options_button.position.x -= 10


func _on_options_mouse_exited() -> void:
	options_button.scale.x -= 0.08
	options_button.scale.y -= 0.08
	options_button.position.x += 10


func _on_button_pressed() -> void:
	selection_animation.show()
	selection_animation.start_animation(5)
