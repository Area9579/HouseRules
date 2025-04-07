class_name CardPlacement
extends Node3D

var has_mouse : bool
var is_selected : bool
var can_discard: bool = false
@export var card : Card = null
@onready var text: Label3D = $Label3D
@onready var organizer = get_parent()
@onready var outline: MeshInstance3D = $Outline

signal placement_clicked( card_placement )


func _process(delta: float) -> void:
	if Input.is_action_just_released("left") and has_mouse:
		placement_clicked.emit( self )
	if Input.is_action_just_released("right") and has_mouse and card != null and can_discard:
		card.discard()
	if has_mouse:
		unhighlight()


func set_card( new_card : Card ):
	self.card = new_card
	
	card.placement_parent = self
	if !has_node("Card"):
		if card.get_parent(): card.get_parent().remove_child(card)
		self.add_child(card)
	card.update_text()
	if text != null:
		text.text = "" 
	
	if organizer is Organizer:
		organizer.place_card(card, int(String(name)[0]), int(String(name)[1]))
		

func set_card_position():
	return
	card.position = self.position

func remove_card():
	if organizer is Organizer:
		organizer.remove_card(int(String(name)[0]), int(String(name)[1]))
		$drop.play()
	if card != null:
		card.placement_parent = null
		card.launchCard()
	card = null
	update_text()

func remove_lady_child():
	card = null
	
func update_text():
	if card == null:
		text.text = "wiz"

func setSelection(select: bool):
	is_selected = select
	outline.visible = select

func highlight():
	if get_parent().name == "HandCardOrganizer":
		can_discard = true
	has_mouse = true
	if !is_selected:
		outline.visible = true


func unhighlight():
	if get_parent().name == "HandCardOrganizer":
		can_discard = false
	has_mouse = false
	if !is_selected:
		outline.visible = false
