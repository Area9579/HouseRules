extends Node3D

@onready var hand_card_organizer: Node3D
@onready var board: Node3D = get_parent().get_node("Board")
@onready var item : Item = null

signal item_clicked( value )

func _ready() -> void:
	if name == "HandLeft":
		hand_card_organizer = $HandCardOrganizer
		for card_placement in hand_card_organizer.get_children():
			card_placement.connect("placement_clicked", board.player_hand_clicked)

func _process(delta: float) -> void:
	if name == "HandRight":
		if item == null:
			return
		if Input.is_action_just_released("left") and item.has_mouse:
			item_clicked.emit( item )
			item.remove()
			item = null

func clear_item(_item : Item):
	if item == _item:
		_item.remove()
		item = null
