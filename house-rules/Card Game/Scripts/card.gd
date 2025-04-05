class_name Card
extends Node3D

@onready var sprite_3d: Sprite3D = $Sprite3D
@onready var sprite_3d_2: Sprite3D = $Sprite3D2
const KING = preload("res://Card Game/Assets/King.png")
const SPADE = preload("res://Card Game/Assets/Spade.png")
var value : int
var color : String
var suit : String
var value_name : String

func _ready() -> void:
	new_card( 0, "", "", "")

func new_card( value : int, color: String, suit: String, value_name : String):
	self.value = value
	self.color = color
	self.suit = suit
	self.value_name = value_name

func set_value( new_value : int ):
	self.value = new_value

func set_color( new_color : String ):
	self.color = new_color

func set_suit( new_suit : String):
	self.suit = new_suit

func set_value_name( value_name : String ):
	self.value_name = value_name

func update_sprite():
	if "king" in suit:
		sprite_3d.set_texture(KING)
	if "spade" in value_name:
		sprite_3d_2.set_texture(SPADE)
