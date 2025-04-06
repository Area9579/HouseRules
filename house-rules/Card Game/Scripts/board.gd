extends Node3D

const CARD = preload("res://Card Game/Scenes/card.tscn")

@onready var lady_card_organizer: Node3D = $LadyCardOrganizer
@onready var player_card_organizer: Node3D = $PlayerCardOrganizer
@onready var card_generator: CardGenerator
@onready var deck = $DECK
@onready var hand = get_parent().get_node("HandLeft")
@onready var drawing = false


@export var selected_card = null
@export var selected_placement = null

signal turn_passed(card)

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
	
	deck.connect("placement_clicked", deck_clicked)

func _process(delta: float) -> void:
	if Input.is_action_just_released("reset"):
		clear_board()

## moving around cards logic
func place_card( card_placement : CardPlacement ):
	var new_card = card_generator.get_new_card()
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
	
	for card_placement in hand.hand_card_organizer.get_children():
		if card_placement.card != null:
			card_placement.remove_card()

func switch_cards( desired_placement ):
	if desired_placement.card != null or selected_placement.card == null: 
		return
	
	selected_placement.card.reparent( desired_placement, false)
	desired_placement.set_card( selected_placement.card )
	selected_placement.card = null
	selected_placement.update_text()
	selected_placement = null
	GameState.state = GameState.next_state
	return desired_placement
	#emit signal

var player_score = [0,0,0]
var player_final = 0

var lady_score = [0,0,0]
var lady_final = 0
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
		player_final = 0
		for i in lady_score:
			player_final += i
		$LadyColumnText/FinalScore.text = str(lady_final)

## signals connect from lady's cards, player's cards, player's hands, and deck, respectively
func lady_card_clicked( card_placement : CardPlacement ):
	if selected_placement == null:
		return
		# add code here to nuke all cards of same suit
	switch_cards( card_placement )

func player_card_clicked( card_placement : CardPlacement ):
	if selected_placement == null:
		return
		# add code here to nuke all cards of same suit
	switch_cards( card_placement )

func player_hand_clicked( card_placement : CardPlacement ):
	selected_card = card_placement.card
	selected_placement = card_placement


func deck_clicked( deck_position ):
	drawing = true
	for card_placement in hand.hand_card_organizer.get_children():
		if card_placement.card == null:
			var new_card = card_generator.get_new_card()
			if new_card == null:
				return
			card_placement.set_card(new_card)
			card_placement.set_card_position()
			GameState.state = GameState.States.player_main
			drawing = false
			return
