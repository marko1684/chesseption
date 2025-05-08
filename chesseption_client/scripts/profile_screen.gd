extends Node2D

@onready var general_info = $GeneralInfo
@onready var notifications_screen = $NotificationsScreen

signal back_to_main_menu_button_pressed()
signal log_out_pressed()

func _ready() -> void:
	notifications_screen.connect("back_button_pressed", Callable(self, "_on_back_button_pressed"))
	general_info.connect("notifications_button_pressed", Callable(self, "_on_notifications_button_pressed"))
	
func _on_notifications_button_pressed() -> void:
	general_info.hide()
	notifications_screen.show()

func _on_back_button_pressed() -> void:
	general_info.get_friends()
	general_info.show()
	notifications_screen.hide()
