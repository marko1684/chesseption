class_name Profile_screen extends Node2D

@onready var back_to_main_menu_button = $Back_to_main_menu
@onready var notifications_button = $Notifications_button
@onready var logout_button = $Log_out_button

signal notifications_button_pressed()
signal back_to_main_menu_button_pressed()
signal log_out_pressed()

func _on_back_to_main_menu_pressed() -> void:
	emit_signal("back_to_main_menu_button_pressed")

func _on_log_out_button_pressed() -> void:
	emit_signal("log_out_pressed")

func _on_notifications_button_pressed() -> void:
	emit_signal("notifications_button_pressed")




func _on_back_to_main_menu_mouse_entered() -> void:
	back_to_main_menu_button.scale.x += 0.08
	back_to_main_menu_button.scale.y += 0.08
	back_to_main_menu_button.position.x -= 10
func _on_back_to_main_menu_mouse_exited() -> void:
	back_to_main_menu_button.scale.x -= 0.08
	back_to_main_menu_button.scale.y -= 0.08
	back_to_main_menu_button.position.x += 10
	
func _on_notifications_button_mouse_entered() -> void:
	notifications_button.scale.x += 0.08
	notifications_button.scale.y += 0.08
	notifications_button.position.x -= 10
func _on_notifications_button_mouse_exited() -> void:
	notifications_button.scale.x -= 0.08
	notifications_button.scale.y -= 0.08
	notifications_button.position.x += 10

func _on_log_out_button_mouse_entered() -> void:
	logout_button.scale.x += 0.08
	logout_button.scale.y += 0.08
	logout_button.position.x -= 10
func _on_log_out_button_mouse_exited() -> void:
	logout_button.scale.x -= 0.08
	logout_button.scale.y -= 0.08
	logout_button.position.x += 10
