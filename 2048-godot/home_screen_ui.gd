extends Node2D
@onready var play_button = $"../TextureButton"
func home_screen():
	play_button.move_to_front()
	play_button.texture_normal = load("res://assets/play/play_not_pressed.png")
	play_button.texture_pressed = load("res://assets/play/play_pressed.png")
