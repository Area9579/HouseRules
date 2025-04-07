class_name CardPlacement
extends Node3D

var has_mouse : bool
var is_selected : bool
@export var card : Card = null
@onready var text: Label3D = $Label3D
@onready var organizer = get_parent()
@onready var outline: MeshInstance3D = $Outline

signal placement_clicked( card_placement )


func _process(delta: float) -> void:
	if Input.is_action_just_released("left") and has_mouse:
		placement_clicked.emit( self )


func set_card( new_card : Card ):
	card = new_card
	card.placement_parent = self
	if !has_node("Card"):
		self.add_child(card)
	card.update_text()
	text.text = ""
	
	
	if organizer is Organizer:
		organizer.place_card(card, int(String(name)[0]), int(String(name)[1]))

func set_card_position():
	return
	card.position = self.position

func remove_card():
	if organizer is Organizer:
		organizer.remove_card(int(String(name)[0]), int(String(name)[1]))
	if card != null:
		card.placement_parent = null
		card.queue_free()
	card = null
	update_text()

func update_text():
	if card == null:
		text.text = "wiz"

func setSelection(select: bool):
	is_selected = select
	outline.visible = select

func _on_area_3d_mouse_entered() -> void:
	has_mouse = true
	if !is_selected:
		outline.visible = true

func _on_area_3d_mouse_exited() -> void:
	has_mouse = false
	if !is_selected:
		outline.visible = false
