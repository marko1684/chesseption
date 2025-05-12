class_name Notification_screen extends Node2D

@onready var back_button = $Back_button
@onready var container = $ScrollContainer/VBoxContainer

var pending_friend_requests: Array = []

signal back_button_pressed()

func _on_button_pressed() -> void:
	add_notification("friend_request","", "okayyylezzgoo")

func _on_button_2_pressed() -> void:
	add_notification("game_invitation","", "srkicool")

func add_notification(type: String, icon: String, username: String) -> void:
	if type == "friend_request":
		if !pending_friend_requests.has(username):
			pending_friend_requests.append(username)
			var friend_request_scene = preload("res://scenes/notifications/friend_request.tscn")
			var friend_request = friend_request_scene.instantiate()
			friend_request.request_is_from = username
			container.add_child(friend_request)
			friend_request.text_label.set_text(username + " has sent you a friend request.") 
	elif type == "game_invitation":
		if !pending_friend_requests.has(username):
			pending_friend_requests.append(username)
			var game_invitation_scene = preload("res://scenes/notifications/game_invitation.tscn")
			var game_invitation = game_invitation_scene.instantiate()
			game_invitation.connect("game_invitation_accepted", Callable(self, "_on_game_invitation_accepted"))
			game_invitation.request_is_from = username
			container.add_child(game_invitation)
			game_invitation.text_label.set_text(username + " has sent you a friend request.") 

func _on_game_invitation_accepted() -> void:
	pass
	
func _on_back_button_mouse_entered() -> void:
	back_button.scale.x += 0.08
	back_button.scale.y += 0.08
	back_button.position.x -= 10
func _on_back_button_mouse_exited() -> void:
	back_button.scale.x -= 0.08
	back_button.scale.y -= 0.08
	back_button.position.x += 10

func _on_back_button_pressed() -> void:
	emit_signal("back_button_pressed")
