class_name CardPosition
extends Node3D

var has_mouse : bool
@export var card : Card = null

signal position_clicked( card_position )

func _process(delta: float) -> void:
	if Input.is_action_just_released("left") and has_mouse:
		position_clicked.emit( self )

func set_card( card : Card ):
	self.card = card

func _on_area_3d_mouse_entered() -> void:
	has_mouse = true


func _on_area_3d_mouse_exited() -> void:
	has_mouse = false
