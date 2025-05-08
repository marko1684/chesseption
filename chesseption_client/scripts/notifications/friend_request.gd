class_name Friend_request extends Control

@onready var accept_button = $ColorRect/accept_button
@onready var decline_button = $ColorRect/decline_button
@onready var text_label = $ColorRect/Label
@onready var icon_sprite = $ColorRect/Player_icon

var request_is_from: String = ""

func _on_accept_button_pressed() -> void:
	friend_request_accepted()
	accept_button.hide()
	decline_button.hide()
	
func _on_decline_button_pressed() -> void:
	accept_button.hide()
	decline_button.hide()

func friend_request_accepted() -> void:
	var data = {
		"player1_id": GameState.your_username,
		"player2_id": request_is_from
	}
	var json_data = JSON.stringify(data)
	var headers = ["Content-Type: application/json"]
	
	$HTTPRequest_accepted.request(
		GameState.server_address + "/player/accept_friend_request",
		headers,
		HTTPClient.METHOD_POST,
		json_data
	)

func _on_http_request_accepted_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	var response = body.get_string_from_utf8()
	if response == "-1" or response == "":
		print('-1')
	else:
		print('jbg frende, moras jest. na silu na silu.')
		add_a_friend(response)

func add_a_friend(respone) -> void:
	pass

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
