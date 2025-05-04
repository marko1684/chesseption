class_name Game_invitation extends Control

@onready var accept_button = $ColorRect/accept_button
@onready var decline_button = $ColorRect/decline_button
@onready var text_label = $ColorRect/Label
@onready var icon_sprite = $ColorRect/Player_icon

signal game_invite_accepted()
signal game_invite_declined()

func _on_accept_button_pressed() -> void:
	accept_button.hide()
	decline_button.hide()
func _on_decline_button_pressed() -> void:
	accept_button.hide()
	decline_button.hide()
	
func _on_decline_button_mouse_entered() -> void:
	decline_button.scale.x += 0.08
	decline_button.scale.y += 0.08
	decline_button.position.x -= 10
func _on_decline_button_mouse_exited() -> void:
	decline_button.scale.x -= 0.08
	decline_button.scale.y -= 0.08
	decline_button.position.x += 10

func _on_accept_button_mouse_entered() -> void:
	accept_button.scale.x += 0.08
	accept_button.scale.y += 0.08
	accept_button.position.x -= 10
func _on_accept_button_mouse_exited() -> void:
	accept_button.scale.x -= 0.08
	accept_button.scale.y -= 0.08
	accept_button.position.x += 10
