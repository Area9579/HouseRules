class_name Board extends Node3D

const CARD = preload("res://Card Game/Scenes/card.tscn")

@onready var lady_card_organizer: Node3D = $LadyCardOrganizer
@onready var player_card_organizer: Node3D = $PlayerCardOrganizer
@onready var card_generator: CardGenerator
@onready var deck = $DECK
@onready var left_hand = $"../PlayerBody/HandLeft"
@onready var right_hand = $"../PlayerBody/HandRight"
@onready var drawing = false

@export var selected_card = null
@export var selected_placement = null

var player_score = [0,0,0]
var player_final = 0

var lady_score = [0,0,0]
var lady_final = 0


func _ready() -> void:
	GameState.board = self

	card_generator = CardGenerator.new()
	
	for card_placement in lady_card_organizer.get_children():
		card_placement.connect("placement_clicked", lady_card_clicked)
	
	for card_placement in player_card_organizer.get_children():
		card_placement.connect("placement_clicked", player_card_clicked)
	
	## signals for player hand are initialized on the node Hand in main so that
	## the signals only connect once children nodes are ready (ik theres other
	## ways around this but oops, this still works)
	
	right_hand.connect("item_clicked", item_clicked)

func _process(delta: float) -> void:
	if not left_hand.hand_is_initialized:
		draw_card()
		draw_card()
		draw_card()
		draw_card()
		draw_card()
		left_hand.hand_is_initialized = true
	#if Input.is_action_just_released("reset"):
		#clear_board()

func item_clicked( item : Item ):
	match item.type:
		"1": print("This is item 1")
		"2": print("This is item 2")
		"3": print("This is item 3")

## moving around cards logic
func place_card( card_placement : CardPlacement, card = null ):
	var new_card = null
	if card == null:
		new_card = card_generator.get_new_card()
	else: new_card = card
	
	if new_card == null:
		return
	card_placement.set_card( new_card )

func clear_board():
	card_generator.get_new_deck()
	for card_placement in lady_card_organizer.get_children():
		if card_placement.card != null:
			card_placement.remove_card()
	
	for card_placement in player_card_organizer.get_children():
		if card_placement.card != null:
			card_placement.remove_card()
	
	for card_placement in left_hand.hand_card_organizer.get_children():
		if card_placement.card != null:
			card_placement.remove_card()

func switch_cards( desired_placement ):
	if desired_placement.card != null or selected_placement.card == null: 
		return
	selected_placement.card.reparent( desired_placement, true)
	desired_placement.set_card( selected_placement.card )
	selected_placement.card = null
	selected_placement.update_text()
	selected_placement.setSelection(false)
	selected_placement = null
	GameState.state = GameState.next_state
	return desired_placement

	
## signals connect from lady's cards, player's cards, player's hands, and deck, respectively
func lady_card_clicked( card_placement : CardPlacement ):
	if selected_placement == null:
		return
		# add code here to nuke all cards of same suit
	#switch_cards( card_placement )

func player_card_clicked( card_placement : CardPlacement ):
	if selected_placement == null:
		return
		# add code here to nuke all cards of same suit
	switch_cards( card_placement )

func player_hand_clicked( card_placement : CardPlacement ):
	selected_card = card_placement.card
	if selected_placement != null:
		selected_placement.setSelection(false)
	selected_placement = card_placement
	if selected_placement.card != null:
		selected_placement.setSelection(true)

func draw_card():
	drawing = true
	for card_placement in left_hand.hand_card_organizer.get_children():
		if card_placement.card == null:
			var new_card = card_generator.get_new_card()
			if new_card == null:
				return
			card_placement.set_card(new_card)
			new_card.global_position = deck.global_position
			
			new_card.rotation = deck.rotation
			#card_placement.set_card_position()
			
	drawing = false
	GameState.state = GameState.States.player_main
	return

func nuke_cards( card ):
	var value
	if card.value_name == "joker":
		value = card.color
	elif card.value_name == "king":
		value = card.suit
	else:
		value = card.value_name
	
	for card_placement in lady_card_organizer.get_children():
		if card_placement != null and card_placement.card != null:
			if card_placement.card.value_name == value:
				card_placement.remove_card()
			elif card_placement.card.suit == value:
				card_placement.remove_card()
			elif card_placement.card.color == value:
				card_placement.remove_card()
	
	for card_placement in player_card_organizer.get_children():
		if card_placement != null and card_placement.card != null:
			if card_placement.card.value_name == value:
				card_placement.remove_card()
			elif card_placement.card.suit == value:
				card_placement.remove_card()
			elif card_placement.card.color == value:
				card_placement.remove_card()



#JUDE SHIT
#JUDE SHIT
#JUDE SHIT
#JUDE SHIT
#JUDE SHIT
#JUDE SHIT




func lady_draw():
	pass
	

var wait = 0
func lady_main():
	wait += 1
	lady_match()
	GameState.emit_signal("turn_pass")

func get_empty_list():
	var empty_list = []
	for i in lady_card_organizer.get_children():
		if i.card == null:
			empty_list += [i]
	return empty_list

func lady_random():
	
	var empty_list = get_empty_list()
	if !empty_list.is_empty():
		var random_choice = empty_list[randi() % empty_list.size()]
		place_card(random_choice)

func lady_match():
	
	var new_card : Card = card_generator.get_new_card()
	
	var chosen_card = null #get the row
	for i in lady_card_organizer.get_children():
		if i.card != null:
			if i.card.value_name == new_card.value_name:
				if int(String(i.name)[0]) == 0:
					
					if $"LadyCardOrganizer/00".card == null: return place_card($"LadyCardOrganizer/00", new_card)
					elif $"LadyCardOrganizer/01".card == null: return place_card($"LadyCardOrganizer/01", new_card)
					elif $"LadyCardOrganizer/02".card == null: return place_card($"LadyCardOrganizer/02", new_card)
				elif int(String(i.name)[0]) == 1:
					
					if $"LadyCardOrganizer/10".card == null: return place_card($"LadyCardOrganizer/10", new_card)
					elif $"LadyCardOrganizer/11".card == null: return place_card($"LadyCardOrganizer/11", new_card)
					elif $"LadyCardOrganizer/12".card == null: return place_card($"LadyCardOrganizer/12", new_card)
				elif int(String(i.name)[0]) == 2:
					
					if $"LadyCardOrganizer/20".card == null: return place_card($"LadyCardOrganizer/20", new_card)
					elif $"LadyCardOrganizer/21".card == null: return  place_card($"LadyCardOrganizer/21", new_card)
					elif $"LadyCardOrganizer/22".card == null: return  place_card($"LadyCardOrganizer/22", new_card)
					
				else: return lady_destroy()
	return lady_destroy()
	
func lady_destroy():
	
	var new_card : Card = card_generator.get_new_card()

	var chosen_card = null #get the row
	for i in player_card_organizer.get_children():
		if i.card != null:
			if i.card.value_name == new_card.value_name:
				if int(String(i.name)[0]) == 0:
					if $"LadyCardOrganizer/00".card == null: return place_card($"LadyCardOrganizer/00", new_card)
					elif $"LadyCardOrganizer/01".card == null: return place_card($"LadyCardOrganizer/01", new_card)
					elif $"LadyCardOrganizer/02".card == null: return place_card($"LadyCardOrganizer/02", new_card)
				elif int(String(i.name)[0]) == 1:
					if $"LadyCardOrganizer/10".card == null: return place_card($"LadyCardOrganizer/10", new_card)
					elif $"LadyCardOrganizer/11".card == null: return place_card($"LadyCardOrganizer/11", new_card)
					elif $"LadyCardOrganizer/12".card == null: return place_card($"LadyCardOrganizer/12", new_card)
				elif int(String(i.name)[0]) == 2:
					if $"LadyCardOrganizer/20".card == null: return place_card($"LadyCardOrganizer/20", new_card)
					elif $"LadyCardOrganizer/21".card == null: return  place_card($"LadyCardOrganizer/21", new_card)
					elif $"LadyCardOrganizer/22".card == null: return  place_card($"LadyCardOrganizer/22", new_card)
				else: return lady_random()
	return lady_random()

func lady_end():
	pass


func update_row(amount : int, col : int, person : int):
	if person == 0: #player
		$PlayerColumnText.get_child(col).text = str(amount)
		player_score[col] = amount
		player_final = 0
		for i in player_score:
			player_final += i
		$PlayerColumnText/FinalScore.text = str(player_final)
	if person == 1:
		$LadyColumnText.get_child(col).text = str(amount)
		lady_score[col] = amount
		lady_final = 0
		for i in lady_score:
			lady_final += i
		$LadyColumnText/FinalScore.text = str(lady_final)

func check_winner():
	var lady_full = true
	var player_full = true
	for i in lady_card_organizer.get_children():
		if i.card == null: lady_full = false
	for i in player_card_organizer.get_children():
		if i.card == null: player_full = false
		if !lady_full or !player_full: return
	if player_final > lady_final: 
		GameState.win()
	else: 
		GameState.lose()
	
