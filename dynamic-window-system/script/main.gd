extends Node

func _ready() -> void:
	WindowManager.register_window("hero_picker", preload("res://scenes/ui/hero_picker_window.tscn")) #register_window bhitra chai window_scene[string] ma scene janxa
	var picker = WindowManager.open_window("hero_picker")
	# Optionally set a custom title if needed (but we already set it in the scene)
