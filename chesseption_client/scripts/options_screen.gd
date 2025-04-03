class_name Options_screen extends Node2D

@onready var back_to_main_menu_button = $Back_to_main_menu
@onready var rules_button = $Rules
@onready var music_slider = $Music_slider
@onready var soundFX_slider = $SoundFX_slider

signal back_to_main_menu_button_pressed()
signal rules_button_pressed()
signal music_volume_changed(number: int)
signal soundFX_volume_changed(number: int)


func _on_back_to_main_menu_pressed() -> void:
	emit_signal("back_to_main_menu_button_pressed")

func _on_h_slider_value_changed(value: float) -> void:
	emit_signal("music_volume_changed", int(music_slider.value ))

func _on_sound_fx_slider_value_changed(value: float) -> void:
	emit_signal("music_volume_changed", int(soundFX_slider.value))

func _on_back_to_main_menu_mouse_entered() -> void:
	back_to_main_menu_button.scale.x += 0.08
	back_to_main_menu_button.scale.y += 0.08
	back_to_main_menu_button.position.x -= 10

func _on_back_to_main_menu_mouse_exited() -> void:
	back_to_main_menu_button.scale.x -= 0.08
	back_to_main_menu_button.scale.y -= 0.08
	back_to_main_menu_button.position.x += 10
	
func _on_rules_pressed() -> void:
	emit_signal("rules_button_pressed")

func _on_rules_mouse_entered() -> void:
	rules_button.scale.x += 0.08
	rules_button.scale.y += 0.08
	rules_button.position.x -= 10

func _on_rules_mouse_exited() -> void:
	rules_button.scale.x -= 0.08
	rules_button.scale.y -= 0.08
	rules_button.position.x += 10
