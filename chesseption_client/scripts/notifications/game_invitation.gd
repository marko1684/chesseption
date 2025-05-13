class_name Game_invitation extends Control

@onready var accept_button = $ColorRect/accept_button
@onready var decline_button = $ColorRect/decline_button
@onready var text_label = $ColorRect/Label
@onready var icon_sprite = $ColorRect/Player_icon

var request_is_from: String = ""
var lobby_id

signal game_invite_accepted()
signal game_invite_declined()

func _on_accept_button_pressed() -> void:
	game_invitation_accepted()
	accept_button.hide()
	decline_button.hide()
func _on_decline_button_pressed() -> void:
	accept_button.hide()
	decline_button.hide()

func game_invitation_accepted() -> void:
	var data = {
		"lobby_id": lobby_id,
		"player_id": GameState.your_username
	}
	var json_data = JSON.stringify(data)
	var headers = ["Content-Type: application/json"]
	
	$HTTPRequest_game_invitation_accepted.request(
		GameState.server_address + "/game/accept_friend_invite_to_lobby",
		headers,
		HTTPClient.METHOD_POST,
		json_data
	)
	
func _on_http_request_game_invitation_accepted_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	var response = body.get_string_from_utf8()
	if response == "-1" or response == "":
		print('-1')
	else:
		GameState.lobby_id = lobby_id
		emit_signal("game_invite_accepted")


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
