class_name Waiting_lobby extends Node2D

@onready var leave_lobby_button = $Leave_lobby_button

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

signal left_lobby()
signal start_joined_custom_game()

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
	emit_signal("back_button_pressed")
	
func _on_leave_lobby_button_pressed() -> void:
	send_left_lobby_http()

func send_left_lobby_http() -> void:
	var data = {
		"lobby_id": GameState.lobby_id,
		"player_id": GameState.your_username
	}
	var json_data = JSON.stringify(data)
	var headers = ["Content-Type: application/json"]
	
	$HTTPRequest_left_lobby.request(
		GameState.server_address + "/game/leave_custom_lobby",
		headers,
		HTTPClient.METHOD_POST,
		json_data
	)

func _on_http_request_left_lobby_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	var response = body.get_string_from_utf8()
	emit_signal("left_lobby")

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
	print("WAITING LOBBY RESPONSE: " + response)
	
	GameState.all_players_names = []
	if error == OK:
		var data = json.get_data()
		var players = data["players"]
		
		if data["started"] == 1:
			GameState.game_type = number_of_players_in_lobby
			emit_signal("start_joined_custom_game")
				
		for player in players:
			if "player_id" in player:
				var player_name = player["player_id"]
				GameState.all_players_names.append(player_name)
		save_response_data()
		if data["started"] == 1:
			GameState.game_type = number_of_players_in_lobby
			emit_signal("start_joined_custom_game")
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
