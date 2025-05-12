class_name login extends Node2D

signal login_pressed(username: String)
@onready var username_textbox = $TextEdit

func _ready():
	Firebase.Auth.login_succeeded.connect(on_login_succeeded)
	Firebase.Auth.signup_succeeded.connect(on_signup_succeeded)
	Firebase.Auth.login_failed.connect(on_login_failed)
	Firebase.Auth.signup_failed.connect(on_signup_failed)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_login_button_pressed():
	var email = %EmailLineEdit.text
	var password = %PasswordLineEdit.text
	Firebase.Auth.login_with_email_and_password(email, password)
	%StateLabel.text = "Logging in"

func _on_signup_button_pressed():
	var email = %EmailLineEdit.text
	var password = %PasswordLineEdit.text
	Firebase.Auth.signup_with_email_and_password(email, password)
	%StateLabel.text = "Singing up"

func on_login_succeeded(auth):
	print(auth)
	%StateLabel.text = "Login success!"
	Firebase.Auth.save_auth(auth)
	get_tree().change_scene_to_file("res://Game.tscn")
	
func on_signup_succeeded(auth):
	print(auth)
	%StateLabel.text = "Sign up success!"
	Firebase.Auth.save_auth(auth)
	get_tree().change_scene_to_file("res://Game.tscn")
	
func on_login_failed(error_code, message):
	print(error_code)
	print(message)
	%StateLabel.text = "Login failed. Error: %s" % message
	
func on_signup_failed(error_code, message):
	print(error_code)
	print(message)
	%StateLabel.text = "Sign up failed. Error: %s" % message


func _on_sign_in_google_button_pressed():
	var provider: AuthProvider = Firebase.Auth.get_GoogleProvider()
	
	if OS.get_name() == "Web":
		# For web
		Firebase.Auth.set_redirect_uri("http://localhost:8060/index.html")
		Firebase.Auth.get_auth_with_redirect(provider)
	else:
		# For desktop
		Firebase.Auth.get_auth_localhost(provider, 8060)
		

func _on_google_login_button_pressed() -> void:
	var username  = username_textbox.text
	emit_signal("login_pressed", username)

func tmp() -> void:
	var provider: AuthProvider = Firebase.Auth.get_GoogleProvider()
	var platform := OS.get_name()

	if platform == "Web":
		Firebase.Auth.set_redirect_uri("http://localhost:8060/index.html")
		Firebase.Auth.get_auth_with_redirect(provider)
	elif platform == "Android":
		Firebase.Auth.get_auth_with_provider(provider)
	else:
		Firebase.Auth.get_auth_localhost(provider, 8060)
	
	var username  = username_textbox.text
	emit_signal("login_pressed", username)
