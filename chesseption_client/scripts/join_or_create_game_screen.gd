class_name Join_or_create_game_screen extends Node2D

@onready var join_game_screen = $JoinGameScreen
@onready var custom_game_lobby = $CustomGameLobby

func _ready() -> void:
	custom_game_lobby.connect("back_button_pressed", Callable(self, "_on_back_button_pressed"))
	join_game_screen.connect("create_custom_game", Callable(self, "_on_create_custom_game"))

func _on_back_button_pressed() -> void:
	join_game_screen.show()
	custom_game_lobby.hide()


func _on_create_custom_game() -> void:
	custom_game_lobby.add_player_to_your_lobby("icon_path", GameState.your_username)
	custom_game_lobby.get_friends()
	join_game_screen.hide()
	custom_game_lobby.show()
