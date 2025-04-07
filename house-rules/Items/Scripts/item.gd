extends Node3D
class_name Item

@onready var timer: Timer = $Timer
@onready var rigid_body_3d: RigidBody3D = $RigidBody3D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var hand = null
@onready var has_mouse : bool = false
@onready var rigidBody: RigidBody3D = $RigidBody3D
var type : String

enum States { falling, QTE, in_hand }
@onready var state

func _init() -> void:
	name = "Item"
	
func _ready() -> void:
	state = States.QTE
	animation_player.play("quick time event")

func _process(delta: float) -> void:
	
	match state:
		States.falling:
			rigid_body_3d.gravity_scale = 1
		States.QTE:
			rigid_body_3d.gravity_scale = 0
		States.in_hand:
			rigid_body_3d.gravity_scale = 0
			if hand == null:
				hand = get_parent().move_item_to_hand( self )
				return
			if !animation_player.is_playing():
				rigid_body_3d.global_position = lerp( rigid_body_3d.global_position, hand.get_node("ItemPosition").global_position, .1 )
			

func remove():
	state = States.falling
	timer.start(2)

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	animation_player.stop()
	rigid_body_3d.position = Vector3(2.2, 0, 0)
	if state != States.in_hand:
		state = States.falling

func launchItem():
	rigidBody.freeze = false
	rigidBody.constant_force.x = 20
	rigidBody.apply_force(Vector3(0,150,60))
	
	
	for i in range(0,3): #random torque generation
		var randTorque = randi_range(1,10)
		match i:
			0:
				rigidBody.add_constant_torque(Vector3(randTorque, 0, 0))
			1:
				rigidBody.add_constant_torque(Vector3(0, randTorque, 0))
			2:
				rigidBody.add_constant_torque(Vector3(0, 0, randTorque))


func _on_timer_timeout() -> void:
	self.queue_free()
