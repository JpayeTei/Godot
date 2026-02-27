extends Node2D
var score_value_in_node:int = 0
var quit_pressed = false
var score = load("res://score.gd")
@onready var home = get_node("home_screen_ui")
@onready var play_button = $TextureButton
@onready var quit_button = $TextureButton2
@onready var score_texture = $score/Score_texture_rect
var game_started = false
var background_texture = preload("res://assets/background.jpg")
var tile_textures = {
	0:    preload("res://assets/0.png"),
	2:    preload("res://assets/2.png"),
	4:    preload("res://assets/4y.png"),
	8:    preload("res://assets/8.png"),
	16:   preload("res://assets/16.png"),
	32:   preload("res://assets/32.png"),
	64:   preload("res://assets/64.png"),
	128:  preload("res://assets/128.png"),
	256:  preload("res://assets/256.png"),
	512:  preload("res://assets/512.png"),
	1024: preload("res://assets/1024.png"),
	2048: preload("res://assets/2048.png"),
}
var table = {}
var row = 4
var column = 4


func _ready() -> void:
	score_texture.visible = false
	play_button.move_to_front()
	quit_button.move_to_front()
	score.update_score()
	background()
	initialize_table()
	home.home_screen()

func _input(event):

	if game_started:
		quit()
		if (gameover() == false && quit_pressed == false):
			if(event.is_action_pressed("a")):
				a()                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        
				randomizer()
				update_ui()

			if(event.is_action_pressed("d")):
				d()                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        
				randomizer()
				update_ui()

			if(event.is_action_pressed("s")):
				s()
				randomizer()
				update_ui()

			if(event.is_action_pressed("w")):
				w()
				randomizer()
				update_ui()
			$score.update_score()
		else:
			$GridContainer.visible = false

func initialize_table() -> void:
	for i in range(0, row):
		for j in range(0, column):
			table[Vector2(i, j)] = 0

func display_table() -> void:
	var rowstring = ""
	for i in range(0, row):
		print(rowstring)
		rowstring = ""
		for j in range(0, column):
			rowstring += str(table[ Vector2( i, j ) ]) + "    "
		
	print(rowstring)
	
func randomizer():
	var random_row = randi()%row
	var random_column = randi()%column
	var random_value
	if randf() < 0.75:
		random_value = 2
	else:
		random_value = 4
	if (table[Vector2(random_row, random_column)] == 0):
		print("inside if",random_row," ", random_column)

		table[Vector2(random_row, random_column)] = random_value
	elif(board_full_check() == false):
		randomizer()

func a():
	for i in range(0, row):
		for j in range(0, column):
			var k = j+1
			while ((k < column) && (j != column-1)):
				if (table[Vector2(i, k)]==0):
					k += 1
				elif (table[Vector2(i, j)] == table[Vector2(i, k)]) || table[Vector2(i, j)] == 0:
					if(table[Vector2(i, j)] == table[Vector2(i, k)]):
						score_value_in_node += (table[Vector2(i,j)])

					table[Vector2(i, j)] = table[Vector2(i, j)] + table[Vector2(i, k)]
					table[Vector2(i, k)] = 0
					k+=1
				else:
					break
func d():
	for i in range(0, row):
		for j in range(column-1, -1, -1):
			var k = j-1
			while ((k >= 0) && (j > 0)):
				if (table[Vector2(i, k)]==0):
					k -= 1
				elif (table[Vector2(i, j)] == table[Vector2(i, k)]) || table[Vector2(i, j)] == 0:
					if(table[Vector2(i, j)] == table[Vector2(i, k)]):
						score_value_in_node += (table[Vector2(i,j)])
					table[Vector2(i, j)] = table[Vector2(i, j)] + table[Vector2(i, k)]
					table[Vector2(i, k)] = 0
					k-=1
				else:
					break
func s():
	for i in range(row-1, -1, -1):
		for j in range(0, column):
			var k = i-1
			while ((k >= 0) && (i > 0)):
				if (table[Vector2(k, j)]==0):
					k -= 1
				elif (table[Vector2(i, j)] == table[Vector2(k, j)]) || table[Vector2(i, j)] == 0:
					if(table[Vector2(i, j)] == table[Vector2(k, j)]):
						score_value_in_node += (table[Vector2(i,j)])
					table[Vector2(i, j)] = table[Vector2(i, j)] + table[Vector2(k, j)]
					table[Vector2(k, j)] = 0
					k-=1
				else:
					break
func w():
	for i in range(0, row):
		for j in range(0, column):
			var k = i+1
			while ((k < row) && (i != column-1)):
				if (table[Vector2(k, j)]==0):
					k += 1
				elif (table[Vector2(i, j)] == table[Vector2(k, j)]) || table[Vector2(i, j)] == 0:
					if(table[Vector2(i, j)] == table[Vector2(k, j)]):
						score_value_in_node += (table[Vector2(i,j)])
					table[Vector2(i, j)] = table[Vector2(i, j)] + table[Vector2(k, j)]
					table[Vector2(k, j)] = 0
					k+=1
				else:
					break

func gameover():
	# check for empty cells first
	for i in range(row):
		for j in range(column):
			if table[Vector2(i, j)] == 0:
				return false  # still empty space, not game over


	# check for possible merges horizontally
	for i in range(row):
		for j in range(column - 1):  # -1 to avoid j+1 out of bounds
			if table[Vector2(i, j)] == table[Vector2(i, j+1)]:
				return false  # can still merge, not game over
	
	# check for possible merges vertically
	for i in range(row - 1):  # -1 to avoid i+1 out of bounds
		for j in range(column):
			if table[Vector2(i, j)] == table[Vector2(i+1, j)]:
				return false  # can still merge, not game over
	return true  # no empty cells and no possible merges, game over
	
func update_ui() -> void:
	var grid = $GridContainer
	grid.move_to_front()
	for i in range(row):
		for j in range(column):
			var index = i * column + j
			var texture_rect = grid.get_child(index)
			var value = table[Vector2(i, j)]
			
			if tile_textures.has(value):
				texture_rect.texture = tile_textures[value]

func board_full_check():
	for i in range(row):
		for j in range(column):
			if table[Vector2(i, j)] == 0:
				return false
	return true

func quit():
	quit_button.ignore_texture_size = true
	quit_button.stretch_mode = TextureButton.STRETCH_SCALE
	quit_button.texture_normal = load("res://assets/quit/quit_not_pressed.png")
	quit_button.texture_pressed = load("res://assets/quit/quit_pressed.png")

func _on_texture_button_2_pressed():
	quit_pressed = true
	play_button.visible = true
	quit_button.visible = false
	home.home_screen()
func _on_texture_button_pressed():
	game_started = true
	play_button.visible = false
	quit_button.visible = true
	randomizer()
	update_ui()

func background():
	var Background_Texture = $BackgroundTextureRect
	Background_Texture.texture = background_texture
