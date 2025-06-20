extends Node3D

@onready var label : Label3D = $Label3D
@onready var mesh : MeshInstance3D = $MeshInstance3D
@onready var card : Card = self.owner

var displayed : bool = false

func _ready() -> void:
	hideTooltip()
	if card.value_name == "joker":
		setText(str(card.value), card.suit, card.color, "\n\nWhen discarded, discards every card of the same color")
		mesh.mesh.size.y = 1.2
		position.z = -.11
	elif card.value_name == "k":
		setText(str(card.value), card.suit, card.color, "\n\nWhen discarded, discards every card of the same suit")
		mesh.mesh.size.y = 1.2
		position.z = -.11
	else:
		setText(str(card.value), card.suit, card.color, "")
		mesh.mesh.size.y = 0.6
		position.z = -.08
	


func showTooltip():
	label.visible = true
	mesh.visible = true


func hideTooltip():
	label.visible = false
	mesh.visible = false


func setText(valueText : String, suitText : String, colorText : String, description : String):
	label.text = "Value: "+ valueText +"\nSuit: " + suitText + "\nColor: " + colorText + description
