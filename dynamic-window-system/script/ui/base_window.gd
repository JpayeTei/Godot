class_name BaseWindow #setting a class aas Base window to open and close window in other scenes and script files
extends Panel #extends a panel node that has other nodes inside it
signal window_opened #this signals if a window is opened and emits to other files that are using this signal
signal window_closed #same thing but closed
@export var window_id: String = "" #Creates a variable I can edit in the inspector. It stores the unique ID for this window type (e.g., "tower_upgrade").
@onready var close_button: Button = $MarginContainer/VBoxContainer/TitleBar/CloseButton #Finds the CloseButton node in the scene and stores a reference, ready as soon as the node enters the scene tree.
@onready var title_label: Label = $MarginContainer/VBoxContainer/TitleBar/TitleLabel#Same pattern as above, but for the title text.
@onready var content: Control = $MarginContainer/VBoxContainer/Content

func _ready() -> void:
	close_button.pressed.connect(close_window)
	#show()

#this is a public method to open the window
#The manager calls this instead of directly calling show(), 
#so we can attach behaviours (like emitting the signal, playing an animation later) in one place.
func open_window() -> void:
	print("Opening: ")
	show()
	window_opened.emit()

func close_window() -> void:
	hide()
	window_closed.emit()

#this funciton allows you to change the title text after the window is open.
func set_title(t: String) -> void:
	title_label.text = t #@onready var title_label: Label = $MarginContainer/VBoxContainer/TitleBar/TitleLabel 
	pass
