class_name Card extends Node3D

@onready var text_box: Label3D = $Label3D
@onready var sprite_3d: Sprite3D = $Sprite3D
@onready var sprite_3d_2: Sprite3D = $Sprite3D2

@export var value : int
@export var color : String
@export var suit : String
@export var value_name : String

func _init( value : int, color: String, suit: String, value_name : String ):
	self.value = value
	self.color = color
	self.suit = suit
	self.value_name = value_name

func initialize( value : int, color: String, suit: String, value_name : String ):
	self.value = value
	self.color = color
	self.suit = suit
	self.value_name = value_name

func update_sprite():
	text_box.set_text(value_name + " " + suit)
