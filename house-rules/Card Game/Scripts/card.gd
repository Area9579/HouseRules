extends Node3D
class_name Card 

@onready var text_box: Label3D = $RigidBody3D/Label3D
@onready var sprite_3d: Sprite3D = $RigidBody3D/Sprite3D
@onready var sprite_3d_2: Sprite3D = $RigidBody3D/Sprite3D2
@onready var rigidBody: RigidBody3D = $RigidBody3D
@onready var mesh_instance_3d: MeshInstance3D = $RigidBody3D/MeshInstance3D

@onready var placement_parent
var lady_hand = null
var launching = false
@export var value : int
@export var color : String
@export var suit : String
@export var value_name : String


func _init( value : int = 10, color: String = "red", suit: String = "e", value_name : String = "king" ):
	self.value = value
	self.color = color
	self.suit = suit
	self.value_name = value_name
	
	
	
func _ready() -> void:
	var texture_name = suit + str(value)
	if value_name == "joker":
		if color == "red":
			texture_name = "jr"
		elif color == "black":
			texture_name = "jb"
	if value_name == "k":
		if suit == "e":
			texture_name = 'ek'
		elif suit == 'h':
			texture_name = 'hk'
		elif suit == 'm':
			texture_name = 'mk'
		elif suit == 'r':
			texture_name = 'rk'
	var h = 0
	
	match texture_name:
		"e1": h = 0
		"e2": h = 1 
		"e3": h = 2
		"e4": h = 3
		"e5": h = 4
		"e6": h = 5
		"e7": h = 6
		"e8": h = 7
		"e9": h = 8
		"e10": h = 9
		"ek": h = 10
		"h1": h = 11
		"h2": h = 12
		"h3": h = 13
		"h4": h = 14
		"h5": h = 15
		"h6": h = 16
		"h7": h = 17
		"h8": h = 18
		"h9": h = 19
		"h10": h = 20
		"hk": h = 21
		"jb": h = 22
		"jr": h = 23
		"m1": h = 24
		"m2": h = 25
		"m3": h = 26
		"m4": h = 27
		"m5": h = 28
		"m6": h = 29
		"m7": h = 30
		"m8": h = 31
		"m9": h = 32
		"m10": h = 33
		"mk": h = 34
		"r1": h = 36
		"r2": h = 37
		"r3": h = 38
		"r4": h = 39
		"r5": h = 40
		"r6": h = 41
		"r7": h = 42
		"r8": h = 43
		"r9": h = 44
		"r10": h = 45
		"rk": h = 46
		
		
		
	mesh_instance_3d.set_surface_override_material(0, StandardMaterial3D.new())
	mesh_instance_3d.get_surface_override_material(0).albedo_texture = Director.textures[h]


func _physics_process(delta: float) -> void:
	if launching: return
	
	if placement_parent != null and not launching:
		if placement_parent.get_parent().name != "HandCardOrganizer":
			global_position = lerp(global_position, placement_parent.global_position, 0.1)
			rotation = lerp(rotation, placement_parent.rotation, 0.1)
		elif placement_parent.get_parent().name == "HandCardOrganizer":
			global_position = lerp(global_position, placement_parent.global_position, 0.1)
			global_rotation = lerp(global_rotation, placement_parent.global_rotation, 0.1)
		
		if placement_parent.get_parent().name == "PlayerCardOrganizer":
			rigidBody.scale = Vector3(1.75, 1.75, 1.75)
		elif placement_parent.get_parent().name == "LadyHandOrganizer":
			rigidBody.scale = Vector3(.2,.2,.2)
		elif placement_parent.get_parent().name == "LadyHandOrganizer":
			rigidBody.scale = Vector3(.2,.2,.2)
		elif placement_parent.get_parent().name == "LadyCardOrganizer":
			rigidBody.scale = Vector3(.2,.2,.2)
		#else:
			#rigidBody.scale = Vector3(1, 1, 1)
	
func set_lady_placement(placement):
	
	print(placement)
func initialize( value : int, color: String, suit: String, value_name : String ):
	self.value = value
	self.color = color
	self.suit = suit
	self.value_name = value_name
	
	

func update_text():
	if text_box != null:
		text_box.set_text(color + "\n" + suit + "\n" + value_name)

func launchCard():
	self.top_level = true
	launching = true
	placement_parent = null
	if rigidBody == null: return
	rigidBody.freeze = false
	rigidBody.constant_force.x = 20
	rigidBody.apply_force(Vector3(0,150,30))
	
	for i in range(0,3): #random torque generation
		var randTorque = randi_range(1,5)
		match i:
			0:
				rigidBody.add_constant_torque(Vector3(randTorque, 0, 0))
			1:
				rigidBody.add_constant_torque(Vector3(0, randTorque, 0))
			2:
				rigidBody.add_constant_torque(Vector3(0, 0, randTorque))
	
	
	await get_tree().create_timer(3).timeout
	self.queue_free()
	
	

func discard():
	get_parent().owner.get_node("Board").nuke_cards(self)
	get_parent().remove_card()
	
	
