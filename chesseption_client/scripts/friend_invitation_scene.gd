class_name Friend_invitation_scene extends Control

@onready var name_label = $ColorRect/Username_label
@onready var icon = $ColorRect/icon_sprite
@onready var invite_button = $ColorRect/Invite_button

func _on_invite_button_pressed() -> void:
	create_game_invitation(name_label.text)

func create_game_invitation(player_name: String) -> void:
	var data = {
		"player1_id": GameState.your_username,
		"player2_id": player_name
	}
	var json_data = JSON.stringify(data)
	var headers = ["Content-Type: application/json"]
	
	$HTTPRequest_game_invitation.request(
		GameState.server_address + "/player/friend_request",
		headers,
		HTTPClient.METHOD_POST,
		json_data
	)

func _on_http_request_game_invitation_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	var response = body.get_string_from_utf8()
	print(response)
