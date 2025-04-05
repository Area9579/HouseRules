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
	print("lady clicked")

func player_card_clicked( card_position : CardPosition ):
	print("player clicked")
