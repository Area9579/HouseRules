extends Node3D

@onready var x: Label3D = $Rows/X
@onready var y: Label3D = $Rows/Y
@onready var z: Label3D = $Rows/Z

var matrix_test = [["00","01","02"],["10","11","12"],["20","21","22"]]
var cards = [[null,null,null],[null,null,null],[null,null,null]]

func _ready() -> void:
	pass

func update_board_column(column : int):
	#group up multipliers
	var list_1 = []
	var list_2 = []
	var list_3 = []
	for u : Card in cards[column]:
		if u != null:
			var card_index = cards[column].find(u)
			#print(card_index)
			# logic for card 1
			if card_index == 0:
				list_1.append(u)
			
			# logic for card 2
			if list_1.size() > 0:
				if card_index == 1 and u.value_name == list_1[0].value_name:
					list_1.append(u)
				elif card_index == 1:
					list_2.append(u)
			
			# logic for card 3
			if card_index == 2:
				if list_1.size() > 0:
					if u.value_name == list_1[0].value_name:
						list_1.append(u)
						break
				if list_2.size() > 0:
					if card_index == 2 and u.value_name == list_2[0].value_name:
						list_2.append(u)
						break
				if card_index == 2:
					list_3.append(u)
		
	var lists = [list_1, list_2, list_3]
	print(lists)
	var stack = 0
	for d : Array in lists:
		var list_stack = 0
		for g : Card in d:
			if g != null:list_stack += g.value # each card gets added on its list
			
		list_stack *= d.size() # each list gets multiplied by size
		stack += list_stack
		
	return stack
