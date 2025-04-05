extends Node3D

@onready var hand_card_organizer: Node3D = $HandCardOrganizer
@onready var board: Node3D = get_parent().get_node("Board")

func _ready() -> void:
	for card_placement in hand_card_organizer.get_children():
		card_placement.connect("placement_clicked", board.player_hand_clicked)
