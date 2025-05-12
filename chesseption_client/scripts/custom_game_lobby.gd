class_name Custom_game_lobby extends Node2D

@onready var back_button = $Back_button
@onready var start_game_button = $Start_game_button
@onready var friendlist_container = $ScrollContainer/VBoxContainer

@onready var player_1_icon = $Player_1/Sprite2D
@onready var player_1_name = $Player_1/Label
@onready var player_2_icon = $Player_2/Sprite2D
@onready var player_2_name = $Player_2/Label
@onready var player_3_icon = $Player_3/Sprite2D
@onready var player_3_name = $Player_3/Label
@onready var player_4_icon = $Player_4/Sprite2D
@onready var player_4_name = $Player_4/Label

var number_of_players_in_lobby = 0

signal back_button_pressed()
signal start_custom_game()

func add_player_to_your_lobby(icon: String, username: String) -> void:
	if number_of_players_in_lobby == 0:
		player_1_name.set_text(username)
	elif number_of_players_in_lobby == 1:
		player_2_name.set_text(username)
	elif number_of_players_in_lobby == 2:
		player_3_name.set_text(username)
	elif number_of_players_in_lobby == 3:
		player_4_name.set_text(username)
	number_of_players_in_lobby += 1

func reset_custom_game_lobby_screen() -> void:
	player_1_name.set_text("")
	player_2_name.set_text("")
	player_3_name.set_text("")
	player_4_name.set_text("")
	number_of_players_in_lobby = 0

func _on_back_button_pressed() -> void:
	reset_custom_game_lobby_screen()
	lobby_destroyed()#emit signal that lobby doesnt exist anymore
	emit_signal("back_button_pressed")
	
func get_friends() -> void:
	var headers = ["Content-Type: application/json"]
	
	$HTTPRequest_get_friends.request(
		GameState.server_address + "/player/get_friends/" + GameState.your_username,
		headers,
		HTTPClient.METHOD_GET
	)

func _on_http_request_get_friends_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	var response_text = body.get_string_from_utf8()
	if response_text == "-1" or response_text == "":
		print("no friends :'(")
	else:
		var json = JSON.new()
		var parse_result = json.parse(response_text)
		if parse_result == OK:
			var friend_data: Array = json.get_data()
			add_friends(friend_data)
		else:
			print("JSON parsing error: ", parse_result)

func add_friends(friend_data: Array) -> void:
	for friend in friendlist_container.get_children():
		friend.queue_free()

	for friend_dict in friend_data:
		if friend_dict.has("uid"):
			var username = str(friend_dict["uid"])
			var friend_invitation_scene = preload("res://scenes/friend_invitation_scene.tscn")
			var friend_invitation = friend_invitation_scene.instantiate()
			friendlist_container.add_child(friend_invitation)
			friend_invitation.name_label.set_text(username)

func lobby_destroyed() -> void:
	var data = {
			"uid": GameState.your_username #and ids of all players currently in lobby
		}
	var json_data = JSON.stringify(data)
	var headers = ["Content-Type: application/json"]
		
	$HTTPRequest_lobby_destroyed.request(
		GameState.server_address + "/player/custom_game/lobby",
		headers,
		HTTPClient.METHOD_POST,
		json_data
	)
		
func _on_http_request_lobby_destroyed_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	var response = body.get_string_from_utf8()
	print(response)

func _on_start_game_button_pressed() -> void:
	emit_signal("start_custom_game")

func start_game() -> void:
	GameState.game_type = number_of_players_in_lobby
	var data = {
		"player_id": GameState.your_username,
		"game_type": number_of_players_in_lobby
	}
	var json_data = JSON.stringify(data)
	var headers = ["Content-Type: application/json"]
	
	$HTTPRequest_start_game.request(
		GameState.server_address + "/game/join_lobby",
		headers,
		HTTPClient.METHOD_POST,
		json_data
	)
	
func _on_http_request_start_game_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	var response = body.get_string_from_utf8()
	print(response)

	var json = JSON.new()
	var error = json.parse(response)

	if error == OK:
		var data = json.get_data()
		var game_id = data["_id"]
		GameState.lobby_id = game_id
		print("Game ID: ", GameState.lobby_id)
		#get_game_state()
	else:
		print("Server is down, error number: ", error)

func _on_back_button_mouse_entered() -> void:
	back_button.scale.x += 0.08
	back_button.scale.y += 0.08
	back_button.position.x -= 10
func _on_back_button_mouse_exited() -> void:
	back_button.scale.x -= 0.08
	back_button.scale.y -= 0.08
	back_button.position.x += 10
func _on_start_game_button_mouse_entered() -> void:
	start_game_button.scale.x += 0.08
	start_game_button.scale.y += 0.08
	start_game_button.position.x -= 10
func _on_start_game_button_mouse_exited() -> void:
	start_game_button.scale.x -= 0.08
	start_game_button.scale.y -= 0.08
	start_game_button.position.x += 10
