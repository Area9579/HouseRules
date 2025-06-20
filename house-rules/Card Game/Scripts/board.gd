class_name Board extends Node3D

const CARD = preload("res://Card Game/Scenes/card.tscn")

@onready var lady_card_organizer: Node3D = $LadyCardOrganizer
@onready var player_card_organizer: Node3D = $PlayerCardOrganizer
@onready var card_generator: CardGenerator
@onready var left_hand = $"../PlayerBody/HandLeft"
@onready var right_hand = $"../PlayerBody/HandRight"
@onready var drawing = false
@onready var deck = $DECK
@onready var audio_stream_player: AudioStreamPlayer = $"../AudioStreamPlayer"
@onready var deck_mesh: Node3D = $deck

@export var selected_card = null
@export var selected_placement = null

var player_score = [0,0,0]
var player_final = 0

var lady_score = [0,0,0]
var lady_final = 0

var player_card_placements : Array = []
var lady_card_placements : Array = []


func _ready() -> void:
	
	for card_placement in player_card_organizer.get_children():
		player_card_placements.append(card_placement)
		card_placement.connect("placement_clicked", player_card_clicked)
	
	for card_placement in lady_card_organizer.get_children():
		lady_card_placements.append(card_placement)
		card_placement.connect("placement_clicked", lady_card_clicked)
	
	GameState.board = self
	GameState.collect_clickable_areas()

	card_generator = CardGenerator.new()
	
	## signals for player hand are initialized on the node Hand in main so that
	## the signals only connect once children nodes are ready (ik theres other
	## ways around this but oops, this still works)


func read_start():
	$"../AudioStreamPlayer".play()
	print('talking')
	$"../BEUASTYYYYY".talking = true

func stop_read():
	$"../AudioStreamPlayer".stop()
	print('stop')
	$"../BEUASTYYYYY".set_stop_talk()

func _process(delta: float) -> void:
	highlight_matched_cards()
	if not left_hand.hand_is_initialized:
		for i in 5:
			draw_card()
		left_hand.hand_is_initialized = true
	#if Input.is_action_just_released("reset"):
		#clear_board()

func highlight_matched_cards():
	var hovered_card = null
	# remove highlights from cards
	for card_placement in player_card_placements:
		card_placement.setSelection(false)
	
	if selected_placement == null or selected_placement.card == null:
		return
	
	for card_placement in player_card_placements:
		if card_placement.has_mouse:
			hovered_card = card_placement.name
			break

	# get column of hovered card
	var col
	if hovered_card != null:
		col = hovered_card.left(1) 
	else:
		col = ""

	# highlight all other cards in column
	for card_placement in player_card_placements:
		if hovered_card != null:
			if card_placement.name.left(1) == col and card_placement.card != null:
				if selected_placement.card.value_name == card_placement.card.value_name:
					card_placement.setSelection(true)
		else:
			card_placement.setSelection(false)

## moving around cards logic
func place_card( card_placement : CardPlacement, card = null ):
	#pos = card_placement
	var new_card = null
	if card == null:
		new_card = card_generator.get_new_card()
	else: new_card = card
	
	if new_card == null:
		return
	card_placement.set_card( new_card )
	
	return card_placement

func clear_board():
	card_generator.get_new_deck()
	
	var arr : Array = []
	
	for child in lady_card_organizer.get_children():
		arr.append(child)
	for child in player_card_organizer.get_children():
		arr.append(child)
	for child in left_hand.hand_card_organizer.get_children():
		arr.append(child)
	
	for card_placement in arr:
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

func play_draw_sound(at_point):
	$PlayerDraw.play(at_point)

func draw_card():
	drawing = true
	for card_placement in left_hand.hand_card_organizer.get_children():
		if card_placement.card == null:
			var new_card = get_new_card()
			if new_card == null:
				return
			card_placement.set_card(new_card)
			
			#card_placement.set_card_position()
			
	drawing = false

func get_new_card():
	var new_card = card_generator.get_new_card()
	if new_card != null:
		new_card.global_position = deck.global_position
		new_card.rotation = deck.rotation
	return new_card


func set_card(placement, card):
	placement.set_card(card)
	card.global_position += Vector3(0,.1,0)


func nuke_cards( card ):
	var value
	if card.value_name == "joker":
		value = card.color
	elif card.value_name == "king":
		value = card.suit
	else:
		value = card.value_name
	
	var arr : Array = []
	
	for child in lady_card_organizer.get_children():
		arr.append(child)
	for child in player_card_organizer.get_children():
		arr.append(child)
	
	for card_placement in arr:
		if card_placement.card != null:
			if card_placement.card.value_name == value:
				card_placement.remove_card()
			elif card_placement.card.suit == value:
				card_placement.remove_card()
			elif card_placement.card.color == value:
				card_placement.remove_card()

## return functions for lady/player card placements
func get_all_card_placements():
	return player_card_placements + lady_card_placements

func get_player_card_placements():
	return player_card_placements

func get_lady_card_placements():
	return lady_card_placements

## signals connect from lady's cards, player's cards, player's hands, and deck, respectively
func lady_card_clicked( card_placement : CardPlacement ):
	if selected_placement == null:
		return
		# add code here to nuke all cards of same suit
	#switch_cards( card_placement )

func player_card_clicked( card_placement : CardPlacement ):
	if GameState.state != GameState.States.player_main: return
	if selected_placement == null:
		return
		# add code here to nuke all cards of same suit
	switch_cards( card_placement )
	$PlayerPlace.stop()
	$PlayerPlace.play()

func player_hand_clicked( card_placement : CardPlacement ):
	selected_card = card_placement.card
	if selected_placement != null:
		selected_placement.setSelection(false)
	selected_placement = card_placement
	if selected_placement.card != null:
		selected_placement.setSelection(true)

#region non-board stuff

func update_row(amount : int, col : int, person : int):
	if person == 0: #player
		$PlayerColumnText.get_child(col).text = str(amount)
		player_score[col] = amount
		player_final = 0
		for i in player_score:
			player_final += i
		$PlayerColumnText/FinalScore.text = str(player_final)
	if person == 1: # lady
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
	if !lady_full and !player_full: return
	if player_final > lady_final: 
		#send a signal to go to the next scene
		SignalBus.emit_signal("changeStage")
	else: #this plays when you lose
		SignalBus.emit_signal("readDialogueSignal", "loseDialogue") #read dialogue
		await SignalBus.dialogueCompletedSignal #wait for dialogue to end
		SignalBus.emit_signal("resetReadDialogue", "loseDialogue") #reset the dialogue
		if get_tree() != null: #reload the scene -> this should change 
			get_tree().reload_current_scene()
			GameState.lose()
			GameState.state = GameState.States.player_draw
#endregion
