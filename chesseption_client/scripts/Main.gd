class_name Main extends Node2D

@onready var main_menu = $Main_menu
@onready var profile_screen = $ProfileScreen
@onready var join_game_screen = $JoinGameScreen
@onready var game_screen = $Game
@onready var end_game_screen = null #TODO

@onready var audio_player = $AudioStreamPlayer2D


func _ready() -> void:
	print('alo')
	main_menu.connect("play_button_pressed", Callable(self, "_on_play_button_pressed"))
	main_menu.connect("view_profile_button_pressed", Callable(self, "_on_view_profile_button_pressed"))
	join_game_screen.connect("back_to_main_menu", Callable(self, "_on_back_to_main_menu_button_pressed"))
	join_game_screen.connect("join_2_player_game", Callable(self, "_on_join_2_player_game"))
	join_game_screen.connect("join_3_player_game", Callable(self, "_on_join_3_player_game"))
	join_game_screen.connect("join_4_player_game", Callable(self, "_on_join_4_player_game"))
	join_game_screen.connect("create_custom_game", Callable(self, "_on_create_custom_game"))

	play_song("res://audio/doodle_song.mp3")

func _on_join_2_player_game() -> void:
	pass
func _on_join_3_player_game() -> void:
	pass
func _on_join_4_player_game() -> void:
	pass
func _on_create_custom_game() -> void:
	pass
func _on_back_to_main_menu_button_pressed() -> void:
	main_menu.show()
	join_game_screen.hide()
	pause_song()
	play_song("res://audio/doodle_song.mp3")
	
func _on_play_button_pressed() -> void:
	main_menu.hide()
	join_game_screen.show()
	pause_song()
	play_song("res://audio/doodle_lobby_song.mp3")

func _on_view_profile_button_pressed() -> void:
	main_menu.hide()
	profile_screen.show()

	
func play_song(path_to_song: String):
	var song = load(path_to_song)
	audio_player.stream = song
	audio_player.play()

func pause_song():
	audio_player.stop()
