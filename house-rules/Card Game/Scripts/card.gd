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



func initialize( value : int, color: String, suit: String, value_name : String, new_position : Vector3):
	self.value = value
	self.color = color
	self.suit = suit
	self.value_name = value_name
	self.global_position = new_position
	#print('initialized')
	#update_sprite()

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
