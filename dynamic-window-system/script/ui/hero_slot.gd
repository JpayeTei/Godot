class_name HeroSlot
extends HBoxContainer

@export var slot_number: int = 1   # 1, 2, or 3
@onready var hero_label: Label = $HeroLabel
@onready var portrait: TextureRect = $Portrait
@onready var pick_button: Button = $PickButton

signal hero_picked(slot_number: int)

func _ready() -> void:
	pick_button.pressed.connect(_on_pick_pressed)
	update_display()

func set_hero_name(hero_name: String) -> void:
	hero_label.text = "Hero %d: %s" % [slot_number, hero_name]
	# Later, when you have a texture, you can do:
	# portrait.texture = load("res://assets/heroes/...")
	# portrait.show()

func update_display() -> void:
	# Placeholder until you have real hero data
	hero_label.text = "Hero %d: %s" % [slot_number, "None"]

func _on_pick_pressed() -> void:
	emit_signal("hero_picked", slot_number)
	print("Pick hero slot ", slot_number)
