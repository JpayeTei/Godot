class_name HeroPicker
extends BaseWindow   # Because the root node already has BaseWindow script

@onready var slots_container: VBoxContainer = $MarginContainer/VBoxContainer/Content/SlotsContainer
@onready var confirm_button: Button = $MarginContainer/VBoxContainer/Content/SlotsContainer/ConfirmButton
var selected_heroes: Array = ["None", "None", "None"]   # Will hold hero IDs or names

func _ready() -> void:
	# The base _ready runs first (connects close button, sets up)
	# We'll connect the slots' signals here.
	# Since the slots are children, they are already ready.
	for slot in slots_container.get_children():
		if slot is HeroSlot:
			slot.hero_picked.connect(_on_hero_picked)
	confirm_button.pressed.connect(_on_confirm_pressed)

func _on_hero_picked(slot_number: int) -> void:
	print("Player wants to change hero in slot ", slot_number)
	# Later: open a hero selection sub‑window or cycle through heroes.
	# For now, we'll just simulate picking a hero:
	var hero_names = ["Gurkha", "Sherpa", "Rajput"]
	# Cycle to next name
	var current_index = hero_names.find(selected_heroes[slot_number - 1])
	var next_index = (current_index + 1) % hero_names.size()
	selected_heroes[slot_number - 1] = hero_names[next_index]
	
	# Update the corresponding slot
	var slot = slots_container.get_child(slot_number - 1)
	if slot is HeroSlot:
		slot.set_hero_name(hero_names[next_index])

func _on_confirm_pressed() -> void:
	print("Confirmed heroes: ", selected_heroes)
	# Later: save this selection, close window, etc.
	close_window()
