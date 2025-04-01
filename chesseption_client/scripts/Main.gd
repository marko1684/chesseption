class_name Main extends Node2D

@onready var main_menu = $Main_menu
@onready var profile_screen = $ProfileScreen
@onready var join_game_screen = $JoinGameScreen
@onready var game_screen = $Game
@onready var options_screen = $OptionsScreen
@onready var end_game_screen = null #TODO

@onready var audio_player = $AudioStreamPlayer2D


func _ready() -> void:
	main_menu.connect("play_button_pressed", Callable(self, "_on_play_button_pressed"))
	main_menu.connect("view_profile_button_pressed", Callable(self, "_on_view_profile_button_pressed"))
	main_menu.connect("options_button_pressed", Callable(self, "_on_view_options_button_pressed"))
	join_game_screen.connect("back_to_main_menu", Callable(self, "_on_back_to_main_menu_button_pressed"))
	join_game_screen.connect("join_2_player_game", Callable(self, "_on_join_2_player_game"))
	join_game_screen.connect("join_3_player_game", Callable(self, "_on_join_3_player_game"))
	join_game_screen.connect("join_4_player_game", Callable(self, "_on_join_4_player_game"))
	join_game_screen.connect("create_custom_game", Callable(self, "_on_create_custom_game"))
	profile_screen.connect("back_to_main_menu_button_pressed", Callable(self, "_on_exit_profile_view"))
	options_screen.connect("back_to_main_menu_button_pressed", Callable(self, "_on_exit_options_view"))

	play_song("res://audio/doodle_song.mp3")

func _on_exit_profile_view() -> void:
	profile_screen.hide()
	main_menu.show()

func _on_exit_options_view() -> void:
	options_screen.hide()
	main_menu.show()
	
func _on_join_2_player_game() -> void:
	game_screen.show()
	join_game_screen.hide()
	pause_song()
	play_song("res://audio/doodle_lobby_song.mp3")
	
func _on_join_3_player_game() -> void:
	pass
func _on_join_4_player_game() -> void:
	pass
func _on_create_custom_game() -> void:
	pass
func _on_back_to_main_menu_button_pressed() -> void:
	main_menu.show()
	join_game_screen.hide()

func _on_play_button_pressed() -> void:
	main_menu.hide()
	join_game_screen.show()

func _on_view_profile_button_pressed() -> void:
	profile_screen.show()
	main_menu.hide()

func _on_view_options_button_pressed() -> void:
	options_screen.show()
	main_menu.hide()
	
func play_song(path_to_song: String):
	var song = load(path_to_song)
	audio_player.stream = song
	audio_player.play()

func pause_song():
	audio_player.stop()
