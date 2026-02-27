extends Node

var score_number = {
	0 : preload("res://assets/numbers/00.png"),
	1 : preload("res://assets/numbers/01.png"),
	2 : preload("res://assets/numbers/02.png"),
	3 : preload("res://assets/numbers/03.png"),
	4 : preload("res://assets/numbers/04.png"),
	5 : preload("res://assets/numbers/05.png"),
	6 : preload("res://assets/numbers/06.png"),
	7 : preload("res://assets/numbers/07.png"),
	8 : preload("res://assets/numbers/08.png"),
	9 : preload("res://assets/numbers/09.png")
}
func update_score():
	var score_texture = $Score_texture_rect
	score_texture.visible=true
	var score_value = get_parent().score_value_in_node
	var score_index = []
	print("Inside update_score()")
	print(score_value)
		
	while score_value != 0:
		score_index.append(score_value%10)
		score_value /= 10
	var grid = $GridContainer
	score_texture.move_to_front()
	grid.move_to_front()
	score_index.reverse()
	for i in range(0, score_index.size()):
		var score_rect = grid.get_child(i)
		if score_number.has(score_index[i]):
			score_rect.texture = score_number[score_index[i]]
