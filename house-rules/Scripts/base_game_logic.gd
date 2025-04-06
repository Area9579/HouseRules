class_name Organizer extends Node3D

var matrix_test = [["00","01","02"],["10","11","12"],["20","21","22"]]
var cards = [[null,null,null],[null,null,null],[null,null,null]]

var list_1 = []
var list_2 = []
var list_3 = []

@export var enemy : Organizer
var id = 0
@onready var board: Node3D = $".."

func _ready() -> void:
	if enemy == $"../PlayerCardOrganizer":
		id = 1
		
func place_card(card, col, row):
	cards[col][row] = card
	board.update_row(update_board_column(col), col, id)
	send_to_enemy()

func remove_card(col, row):
	cards[col][row] = null
	update_board_column(col)

func send_to_enemy():
	enemy.receive_enemy(cards)

func receive_enemy(data):
	var card_index_1 = -1
	for i in data:
		card_index_1 += 1
		for u : Card in i:
			if u != null:
				for x in cards[card_index_1]:
					var new_index = cards[card_index_1].find(x)
					if x != null:
						if u.value_name == cards[card_index_1][new_index].value_name:
							cards[card_index_1][new_index].get_parent().remove_card()
							print('removed')
	

func update_whole_board():
	update_board_column(0)
	update_board_column(1)
	update_board_column(2)

func update_board_column(column : int):
	#group up multipliers
	list_1 = []
	list_2 = []
	list_3 = []
	
	for u : Card in cards[column]:
		if u != null:
			if check_if_match(u, column) == false:
				check_if_empty(u)
		
		
	var lists = [list_1, list_2, list_3]
	
	var stack = 0
	for d : Array in lists:
		var list_stack = 0
		for g : Card in d:
			if g != null:list_stack += g.value # each card gets added on its list
		list_stack *= d.size() # each list gets multiplied by size
		stack += list_stack
		
	return stack

func check_if_match(card : Card, column):
	var card_index = cards[column].find(card)
	for x : Card in list_1:
		if x.value_name == card.value_name:
			list_1.append(card)
			return true
	for x : Card in list_2:
		if x.value_name == card.value_name:
			list_2.append(card)
			return true
	for x : Card in list_3:
		if x.value_name == card.value_name:
			list_3.append(card)
			return true
	return false

func check_if_empty(card):
	if list_3.is_empty(): 
		list_3.append(card)
		return
	elif list_2.is_empty():
		list_2.append(card)
		return
	elif list_1.is_empty(): 
		list_1.append(card)
