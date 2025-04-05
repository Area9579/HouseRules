extends Node3D
const PRELOAD_CARD = preload("res://Card Game/Scenes/card.tscn")
@onready var lady_card_organizer: Node3D = $LadyCardOrganizer
@onready var player_card_organizer: Node3D = $PlayerCardOrganizer

func _ready() -> void:
	var lady_card_positions = lady_card_organizer.get_children()
	var player_card_positions = player_card_organizer.get_children()
	
	for card_position in lady_card_positions:
		card_position.connect("position_clicked", lady_card_clicked)
	
	for card_position in player_card_positions:
		card_position.connect("position_clicked", player_card_clicked)

func lady_card_clicked( card_position : CardPosition ):
	create_and_add_new_card( card_position )

func player_card_clicked( card_position : CardPosition ):
	create_and_add_new_card( card_position )

func create_and_add_new_card( card_position ):
	var _card = PRELOAD_CARD.instantiate()
	card_position.set_card(_card)
	_card.initialize(10, "red", "spade", "king", card_position.global_position)
