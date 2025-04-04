class_name Challange_window extends Node2D

@onready var text_label = $ColorRect/Label
@onready var challange_button = $Challange_button

signal move_challanged()

func set_challange_window_text(player_that_made_a_move: String) -> void:
	#player_that_made_a_move is white black red or blue
	text_label.set_text("Do you want to challange " + player_that_made_a_move + " players move?")
	
func _on_challange_button_pressed() -> void:
	emit_signal("move_challanged")

func _on_challange_button_mouse_entered() -> void:
	challange_button.scale.x += 0.05
	challange_button.scale.y += 0.05
	challange_button.position.x -= 15
	challange_button.position.y -= 5


func _on_challange_button_mouse_exited() -> void:
	challange_button.scale.x -= 0.05
	challange_button.scale.y -= 0.05
	challange_button.position.x += 15
	challange_button.position.y += 5
