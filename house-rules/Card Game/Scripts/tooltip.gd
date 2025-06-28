extends Node3D

@onready var label : Label3D = $Label3D
@onready var mesh : MeshInstance3D = $MeshInstance3D
@onready var parent = self.owner

var displayed : bool = false


func _ready() -> void:
	hideTooltip()
	checkTooltipType()


func showTooltip():
	label.visible = true
	mesh.visible = true


func hideTooltip():
	label.visible = false
	mesh.visible = false


func setCardText(valueText : String, suitText : String, colorText : String, description : String):
	label.text = "Value: "+ valueText +"\nSuit: " + suitText + "\nColor: " + colorText + description


func setItemText(description : String):
	label.text = description


func cardSetup():
	if parent.value_name == "joker":
		setCardText(str(parent.value), parent.suit, parent.color, "\n\nWhen discarded, discards every card of the same color")
		mesh.mesh.size.y = 1.2
		position.z = -.11
		rotation_degrees = Vector3(0, 0, 0)
	elif parent.value_name == "k":
		setCardText(str(parent.value), parent.suit, parent.color, "\n\nWhen discarded, discards every card of the same suit")
		mesh.mesh.size.y = 1.2
		position.z = -.11
		rotation_degrees = Vector3(0, 0, 0)
	else:
		setCardText(str(parent.value), parent.suit, parent.color, "")
		mesh.mesh.size.y = 0.6
		position.z = -.08
		rotation_degrees = Vector3(0, 0, 0)


func itemSetup():
	if parent.type == "dentures":
		mesh.mesh.size.y = 0.6
		position = Vector3(0, 0.13, 0)
		rotation_degrees = Vector3(90, -60, 0)
		setItemText("Use: left click" + "\n\nEats an entire row of cards")
	elif parent.type == "brick":
		mesh.mesh.size.y = 0.6
		position = Vector3(0, 0.13, 0)
		rotation_degrees = Vector3(90, -60, 0)
		setItemText("Use: left click" + "\n\nSkip the lady's turn twice")


func checkTooltipType():
	if parent is Card:
		cardSetup()
	elif parent is Item:
		await SignalBus.sendItemType
		itemSetup()
