extends Node3D
const CARD = preload("res://Card Game/Scenes/card.tscn")
@onready var lady_card_organizer: Node3D = $LadyCardOrganizer
@onready var player_card_organizer: Node3D = $PlayerCardOrganizer
@onready var card_generator: CardGenerator
@onready var deck: CardPlacement = $DECK

func _ready() -> void:
	card_generator = CardGenerator.new()
	
	for card_placement in lady_card_organizer.get_children():
		card_placement.connect("placement_clicked", lady_card_clicked)
	
	for card_placement in player_card_organizer.get_children():
		card_placement.connect("placement_clicked", player_card_clicked)
	
	deck.connect("placement_clicked", deck_clicked)

func lady_card_clicked( card_placement : CardPlacement ):
	place_card( card_placement )

func player_card_clicked( card_placement : CardPlacement ):
	place_card( card_placement )

func place_card( card_placement ):
	var new_card = card_generator.get_new_card()
	if new_card == null:
		return
	card_placement.set_card( new_card )

func deck_clicked( deck_position ):
	card_generator.get_new_deck()
	for card_placement in lady_card_organizer.get_children():
		if card_placement.card != null:
			card_placement.remove_card()
	
	for card_placement in player_card_organizer.get_children():
		if card_placement.card != null:
			card_placement.remove_card()
