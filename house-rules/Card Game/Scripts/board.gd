extends Node3D
const CARD = preload("res://Card Game/Scenes/card.tscn")
@onready var lady_card_organizer: Node3D = $LadyCardOrganizer
@onready var player_card_organizer: Node3D = $PlayerCardOrganizer
@onready var card_generator: CardGenerator

func _ready() -> void:
	card_generator = CardGenerator.new()
	var lady_card_positions = lady_card_organizer.get_children()
	var player_card_positions = player_card_organizer.get_children()
	
	for card_position in lady_card_positions:
		card_position.connect("position_clicked", lady_card_clicked)
	
	for card_position in player_card_positions:
		card_position.connect("position_clicked", player_card_clicked)

func lady_card_clicked( card_position : CardPosition ):
	place_card( card_position )

func player_card_clicked( card_position : CardPosition ):
	place_card( card_position )

func place_card( card_position ):
	card_position.set_card( card_generator.get_new_card() )
