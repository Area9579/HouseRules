extends Node3D

@onready var hand_card_organizer: Node3D
@onready var board: Node3D = get_parent().get_node("Board")
@onready var hand_is_initialized : bool = false

func _ready() -> void:
	if name == "HandLeft":
		hand_card_organizer = $HandCardOrganizer
		for card_placement in hand_card_organizer.get_children():
			card_placement.connect("placement_clicked", board.player_hand_clicked)
