extends Node3D
class_name Card 

@onready var text_box: Label3D = $RigidBody3D/Label3D
@onready var sprite_3d: Sprite3D = $RigidBody3D/Sprite3D
@onready var sprite_3d_2: Sprite3D = $RigidBody3D/Sprite3D2
@onready var rigidBody: RigidBody3D = $RigidBody3D

@export var value : int
@export var color : String
@export var suit : String
@export var value_name : String


func _init( value : int = 10, color: String = "red", suit: String = "diamonds", value_name : String = "king" ):
	self.value = value
	self.color = color
	self.suit = suit
	self.value_name = value_name

func initialize( value : int, color: String, suit: String, value_name : String ):
	self.value = value
	self.color = color
	self.suit = suit
	self.value_name = value_name

func update_text():
	text_box.set_text(color + "\n" + suit + "\n" + value_name)

func launchCard():
	rigidBody.freeze = false
	rigidBody.constant_force.x = 20
	rigidBody.apply_force(Vector3(0,150,30))
	
	#for child in rigidBody.get_children():
		#child.scale.x = 0.025
		#child.scale.y = 0.025
		#child.scale.z = 0.025
	
	for i in range(0,3): #random torque generation
		var randTorque = randi_range(1,10)
		match i:
			0:
				rigidBody.add_constant_torque(Vector3(randTorque, 0, 0))
			1:
				rigidBody.add_constant_torque(Vector3(0, randTorque, 0))
			2:
				rigidBody.add_constant_torque(Vector3(0, 0, randTorque))
