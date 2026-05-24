#this is the main file where all the things are run from
#I have created a Test_window scene which is a duplicate of BaseWindow.tscn

extends Node

func _ready() -> void:
	print("main scene ready")
	WindowManager.register_window("test_window", preload("res://scenes/ui/Test_Window.tscn"))
	print("register")
	var win = WindowManager.open_window("test_window")
	print("open window returned", win)
