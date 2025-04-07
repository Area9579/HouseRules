extends Node3D
class_name CardGenerator
const CARD = preload("res://Card Game/Scenes/card.tscn")
var default_list : Array
var available_list : Array
var card_values_array : Array

func _init() -> void:
	add_values_to_card_values_array()
	for i in 52:
		var value = clamp((i % 13), 1, 13)
		var value_name = card_values_array.get(i % 13)
		var suit = "e" if i % 4 == 0 else "m" if i % 4 == 1 else "h" if i % 4 == 2 else "r"
		var color = "red" if suit == "r" else "red" if suit == "h" else "black"
		var _card = CARD.instantiate()
		_card.name = "Card"
		_card.initialize( value, color, suit, value_name )
		default_list.append( _card )
	var b_joker = CARD.instantiate()
	b_joker.name = "Card"
	
	b_joker.initialize( 10, "black", "joker", "joker")
	
	#set texture here
	var r_joker = CARD.instantiate()
	
	r_joker.name = "Card"
	r_joker.initialize( 10, "black", "joker", "joker" )
	
	default_list.append(b_joker)
	default_list.append(r_joker)
	
	for card in default_list:
		available_list.append(card.duplicate())
	available_list.shuffle()

func get_new_card():
	return available_list.pop_front()

func get_new_deck():
	available_list.clear()
	available_list.append_array(default_list)
	available_list.shuffle()

func add_values_to_card_values_array():
	card_values_array.append("ace")
	card_values_array.append("two")
	card_values_array.append("three")
	card_values_array.append("four")
	card_values_array.append("five")
	card_values_array.append("six")
	card_values_array.append("seven")
	card_values_array.append("eight")
	card_values_array.append("nine")
	card_values_array.append("ten")
	card_values_array.append("jack")
	card_values_array.append("queen")
	card_values_array.append("king")
