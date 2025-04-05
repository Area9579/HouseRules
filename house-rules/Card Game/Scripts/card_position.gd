class_name CardPosition
extends Node3D

var has_mouse : bool
@export var card : Card = null
@onready var text: Label3D = $Label3D

signal position_clicked( card_position )

func _process(delta: float) -> void:
	if Input.is_action_just_released("left") and has_mouse:
		position_clicked.emit( self )

func set_card( new_card : Card ):
	card = new_card
	#card.position = self.global_position
	self.add_child(card)
	card.update_text()
	text.text = ""

func _on_area_3d_mouse_entered() -> void:
	has_mouse = true

func _on_area_3d_mouse_exited() -> void:
	has_mouse = false
