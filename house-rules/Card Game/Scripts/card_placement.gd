class_name CardPlacement
extends Node3D

var has_mouse : bool
@export var card : Card = null
@onready var text: Label3D = $Label3D

signal placement_clicked( card_placement )


func _process(delta: float) -> void:
	if Input.is_action_just_released("left") and has_mouse:
		placement_clicked.emit( self )

func set_card( new_card : Card ):
	card = new_card
	if !has_node("Card"):
		self.add_child(card)
	card.update_text()
	text.text = ""

func set_card_position():
	card.position = self.position

func remove_card():
	if card != null:
		card.queue_free()
	card = null
	update_text()

func update_text():
	if card == null:
		text.text = "wiz"

func _on_area_3d_mouse_entered() -> void:
	has_mouse = true

func _on_area_3d_mouse_exited() -> void:
	has_mouse = false
