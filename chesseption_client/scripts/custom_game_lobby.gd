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
var all_players_names: Array = []
var all_players_icons: Array = []

signal back_button_pressed()
signal start_custom_game()

func initialize() -> void:
	add_player_to_your_lobby("icon_path", GameState.your_username)
	get_friends()
	var data = {
			"player_id": GameState.your_username
		}
	var json_data = JSON.stringify(data)
	var headers = ["Content-Type: application/json"]
	
	$HTTPRequest_initialization.request(
		GameState.server_address + "/game/create_custom_lobby/",
		headers,
		HTTPClient.METHOD_POST,
		json_data
	)

func _on_http_request_initialization_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	var response = body.get_string_from_utf8()
	var json = JSON.new()
	var error = json.parse(response)

	if error == OK:
		var data = json.get_data()
		var game_id = data["_id"]
		GameState.lobby_id = game_id
		print(GameState.lobby_id)
		poll()
	else:
		print("Server is down, error number: ", error)

func add_player_to_your_lobby(icon: String, username: String) -> void:
	number_of_players_in_lobby += 1
	all_players_names.append(username)
	all_players_icons.append(icon)
	
func reset_custom_game_lobby_screen() -> void:
	player_1_name.set_text("")
	player_2_name.set_text("")
	player_3_name.set_text("")
	player_4_name.set_text("")
	number_of_players_in_lobby = 0
	all_players_names = []
	all_players_icons = []
	
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
			"lobby_id": GameState.lobby_id
		}
	var json_data = JSON.stringify(data)
	var headers = ["Content-Type: application/json"]
		
	$HTTPRequest_lobby_destroyed.request(
		GameState.server_address + "/game/delete_custom_lobby",
		headers,
		HTTPClient.METHOD_POST,
		json_data
	)
		
func _on_http_request_lobby_destroyed_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	var response = body.get_string_from_utf8()
	print(response)

func _on_start_game_button_pressed() -> void:
	if number_of_players_in_lobby >= 2  and number_of_players_in_lobby <= 4:
		GameState.game_type = number_of_players_in_lobby
		start_game()
		emit_signal("start_custom_game")

func start_game() -> void:
	var data = {
		"lobby_id": GameState.lobby_id
	}
	var json_data = JSON.stringify(data)
	var headers = ["Content-Type: application/json"]
	
	$HTTPRequest_start_game.request(
		GameState.server_address + "/game/start_custom_game",
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

func poll() -> void:
	var headers = ["Content-Type: application/json"]
	
	$HTTPRequest_poll.request(
		GameState.server_address + "/game/get_lobby_state/" + GameState.lobby_id,
		headers,
		HTTPClient.METHOD_GET
	)
		
func _on_http_request_poll_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	var response = body.get_string_from_utf8()
	var json = JSON.new()
	var error = json.parse(response)
	
	GameState.all_players_names = []
	if response != "0" :
		if error == OK:
			var data = json.get_data()
			var players = data["players"]
			
			for player in players:
				if "player_id" in player:
					var player_name = player["player_id"]
					GameState.all_players_names.append(player_name)
			save_response_data()
			
			if data["started"] == 1:
				emit_signal("start_custom_game")
			else:
				await get_tree().create_timer(2).timeout
				poll()

func save_response_data() -> void:
	reset_custom_game_lobby_screen()
	var players: Array = []
	for player_name in GameState.all_players_names:
		add_player_to_your_lobby("icon", player_name)
	update_players_in_lobby_names(all_players_names)
	update_players_in_lobby_icons(all_players_icons)
	
func update_players_in_lobby_names(all_players_names: Array) -> void:
	player_1_name.set_text(all_players_names[0])
	if number_of_players_in_lobby == 2:
		player_2_name.set_text(all_players_names[1])
		if number_of_players_in_lobby == 3:
			player_3_name.set_text(all_players_names[2])
			if number_of_players_in_lobby == 4:
				player_4_name.set_text(all_players_names[3])
		
func update_players_in_lobby_icons(all_players_icons: Array) -> void:
	pass
