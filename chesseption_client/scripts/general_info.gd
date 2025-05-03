class_name Profile_screen extends Node2D

@onready var back_to_main_menu_button = $Back_to_main_menu
@onready var notifications_button = $Notifications_button
@onready var logout_button = $Log_out_button
@onready var send_friend_request_button = $Send_friend_request_button
@onready var friend_request_name = $Friend_request_name
@onready var name_lenght_warning_label = $name_length_warning_label
@onready var player_not_found_warning_label = $player_not_found_label
@onready var request_sent_label = $request_sent_label
@onready var edit_username_button = $Edit_username_button
@onready var username_edit = $Username_edit
@onready var username_label = $Username_label
@onready var finish_username_editing_button = $Finish_username_editing
@onready var username_taken_label = $Username_taken_label

signal notifications_button_pressed()
signal back_to_main_menu_button_pressed()
signal log_out_pressed()

func _on_back_to_main_menu_pressed() -> void:
	hide_all_warning_labels()
	finish_username_editing_button.hide()
	edit_username_button.show()
	username_label.show()
	username_edit.hide()
	emit_signal("back_to_main_menu_button_pressed")
	
func hide_all_warning_labels() -> void:
	request_sent_label.hide()
	player_not_found_warning_label.hide()
	name_lenght_warning_label.hide()
	username_taken_label.hide()
	
func _on_log_out_button_pressed() -> void:
	hide_all_warning_labels()
	finish_username_editing_button.hide()
	edit_username_button.show()
	username_label.show()
	username_edit.hide()
	emit_signal("log_out_pressed")

func _on_notifications_button_pressed() -> void:
	hide_all_warning_labels()
	finish_username_editing_button.hide()
	edit_username_button.show()
	username_label.show()
	username_edit.hide()
	emit_signal("notifications_button_pressed")

func _on_edit_username_button_pressed() -> void:
	username_edit.show()
	username_label.hide()
	edit_username_button.hide()
	finish_username_editing_button.show()
	
func _on_finish_username_editing_pressed() -> void:
	var new_username = username_edit.text
	if new_username != GameState.your_username:
		send_new_username_to_server(new_username)
	else: #If name is not changed dont send the request
		hide_all_warning_labels()
		username_edit.hide()
		username_label.show()
		edit_username_button.show()
		finish_username_editing_button.hide()
		
func send_new_username_to_server(new_username: String) -> void:
	var data = {
		"uid": GameState.your_username,
		"new_id": new_username
	}
	var json_data = JSON.stringify(data)
	var headers = ["Content-Type: application/json"]
	
	$HTTPRequest_change_username.request(
		GameState.server_address + "/player/friend_request",
		headers,
		HTTPClient.METHOD_POST,
		json_data
	)

func _on_http_request_change_username_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	var response = body.get_string_from_utf8()
	if response == "-1" or response == "":
		username_taken_label.show()
	else:
		username_taken_label.hide()
		var json = JSON.new()
		var error = json.parse(response)
		var data = json.get_data()
		GameState.your_username = data["uid"]
		username_edit.hide()
		username_label.show()
		edit_username_button.show()
		finish_username_editing_button.hide()

	
func _on_send_friend_request_button_pressed() -> void:
	hide_all_warning_labels()
	var player_name = friend_request_name.text
	if player_name.length() <= 16 and player_name.length() >= 4:
		create_friend_request(player_name)
	else:
		name_lenght_warning_label.show()

func create_friend_request(player_name: String) -> void:
	var data = {
		"uid": GameState.your_username,
		"icon": GameState.your_icon,
		"player_id": player_name
	}
	var json_data = JSON.stringify(data)
	var headers = ["Content-Type: application/json"]
	
	$HTTPRequest_friend_request.request(
		GameState.server_address + "/player/friend_request",
		headers,
		HTTPClient.METHOD_POST,
		json_data
	)

func _on_http_request_friend_request_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	var response = body.get_string_from_utf8()
	if response == "-1" or response == "":
		player_not_found_warning_label.show()
	else:
		request_sent_label.show()

	
func _on_send_friend_request_button_mouse_exited() -> void:
	send_friend_request_button.scale.x += 0.08
	send_friend_request_button.scale.y += 0.08
	send_friend_request_button.position.x -= 10
func _on_send_friend_request_button_mouse_entered() -> void:
	send_friend_request_button.scale.x -= 0.08
	send_friend_request_button.scale.y -= 0.08
	send_friend_request_button.position.x += 10
	
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

func _on_edit_username_button_mouse_entered() -> void:
	edit_username_button.scale.x += 0.08
	edit_username_button.scale.y += 0.08
	edit_username_button.position.x -= 10
func _on_edit_username_button_mouse_exited() -> void:
	edit_username_button.scale.x -= 0.08
	edit_username_button.scale.y -= 0.08
	edit_username_button.position.x += 10

func _on_finish_username_editing_mouse_entered() -> void:
	finish_username_editing_button.scale.x += 0.08
	finish_username_editing_button.scale.y += 0.08
	finish_username_editing_button.position.x -= 10
func _on_finish_username_editing_mouse_exited() -> void:
	finish_username_editing_button.scale.x -= 0.08
	finish_username_editing_button.scale.y -= 0.08
	finish_username_editing_button.position.x += 10
