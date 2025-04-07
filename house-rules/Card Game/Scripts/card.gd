extends Node3D
class_name Card 

@onready var text_box: Label3D = $RigidBody3D/Label3D
@onready var sprite_3d: Sprite3D = $RigidBody3D/Sprite3D
@onready var sprite_3d_2: Sprite3D = $RigidBody3D/Sprite3D2
@onready var rigidBody: RigidBody3D = $RigidBody3D
@onready var mesh_instance_3d: MeshInstance3D = $RigidBody3D/MeshInstance3D

@onready var placement_parent
var lady_hand = null

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
	for i in Director.textures:
		if i.resource_name == texture_name:
			mesh_instance_3d.set_surface_override_material(0, StandardMaterial3D.new())
			mesh_instance_3d.get_surface_override_material(0).albedo_texture = i
			return
	
func _physics_process(delta: float) -> void:
	
	if placement_parent != null:
		if placement_parent.get_parent().name != "HandCardOrganizer":
			global_position = lerp(global_position, placement_parent.global_position, 0.1)
			rotation = lerp(rotation, placement_parent.rotation, 0.1)
		elif placement_parent.get_parent().name == "HandCardOrganizer":
			global_position = lerp(global_position, placement_parent.global_position, 0.1)
			global_rotation = lerp(global_rotation, placement_parent.global_rotation, 0.1)
		
		if placement_parent.get_parent().name == "PlayerCardOrganizer":
			rigidBody.scale = Vector3(1.35, 1.35, 1.35)
		elif placement_parent.get_parent().name == "LadyHandOrganizer":
			rigidBody.scale = Vector3(.2,.2,.2)
		elif placement_parent.get_parent().name == "LadyCardOrganizer":
			rigidBody.scale = Vector3(.2,.2,.2)
		else:
			rigidBody.scale = Vector3(1, 1, 1)
	
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
	if rigidBody == null: return
	rigidBody.freeze = false
	rigidBody.constant_force.x = 20
	rigidBody.apply_force(Vector3(0,150,30))
	
	for i in range(0,3): #random torque generation
		var randTorque = randi_range(1,10)
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
	
	
