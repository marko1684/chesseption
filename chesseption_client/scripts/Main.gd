class_name Main extends Node2D

@onready var main_menu = $Main_menu
@onready var profile_screen = $ProfileScreen
@onready var join_game_screen = $JoinGameScreen
@onready var game_screen = $Game
@onready var options_screen = $OptionsScreen
@onready var end_game_screen = null #TODO
@onready var rules_screen = $Rules
@onready var music_player = $Music_player
@onready var soundFX_player = $SoundFX_player
@onready var login_screen = $Login

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
	profile_screen.connect("log_out_pressed", Callable(self, "_on_log_out_pressed"))
	options_screen.connect("back_to_main_menu_button_pressed", Callable(self, "_on_exit_options_view"))
	options_screen.connect("rules_button_pressed", Callable(self, "_on_rules_button_pressed"))
	options_screen.connect("music_volume_changed", Callable(self, "_on_music_volume_changed"))
	options_screen.connect("soundFX_volume_changed", Callable(self, "_on_soundFX_volume_changed"))
	rules_screen.connect("back_to_options_screen", Callable(self, "_on_back_to_options_screen"))
	login_screen.connect("login_pressed", Callable(self, "_on_login_pressed"))
	play_song("res://audio/doodle_song.mp3")
	

func _on_log_out_pressed() -> void:
	profile_screen.hide()
	login_screen.show()
	
func _on_login_pressed() -> void:
	login_screen.hide()
	main_menu.show()
	
func _on_music_volume_changed(value: int) -> void:
	var min_db = -50
	var max_db = 0
	var volume_db = lerp(min_db, max_db, value / 10.0)
	if value == 0:
		music_player.volume_db = -100
	else:
		music_player.volume_db = volume_db
	
func _on_soundFX_volume_changed(value: int) -> void:
	var min_db = -50
	var max_db = 0
	var volume_db = lerp(min_db, max_db, value / 10.0)
	if value == 0:
		soundFX_player.volume_db = -100
	else:
		soundFX_player.volume_db = volume_db


func _on_back_to_options_screen() -> void:
	rules_screen.hide()
	options_screen.show()

func _on_rules_button_pressed() -> void:
	options_screen.hide()
	rules_screen.show()

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
	game_screen.show()
	join_game_screen.hide()
	pause_song()
	play_song("res://audio/doodle_lobby_song.mp3")
	
func _on_join_4_player_game() -> void:
	game_screen.show()
	join_game_screen.hide()
	pause_song()
	play_song("res://audio/doodle_lobby_song.mp3")
	
func _on_create_custom_game() -> void:
	game_screen.show()
	join_game_screen.hide()
	pause_song()
	play_song("res://audio/doodle_lobby_song.mp3")
	
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
	music_player.stream = song
	music_player.play()

func pause_song():
	music_player.stop()
