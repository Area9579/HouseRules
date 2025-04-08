extends Node3D
@onready var hand_left: Node3D = %HandLeft
@onready var realhand: Node3D = $"../realhand"
@onready var player_body: Node3D = $"../.."

func _process(delta: float) -> void:
	global_position = lerp(global_position, hand_left.global_position, 0.1)
