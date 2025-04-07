extends Node3D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var animation_player_2: AnimationPlayer = $AnimationPlayer2
@onready var timer: Timer = $Timer

@onready var state : bool = false

func _ready() -> void:
	animation_player.play("scroll")
	animation_player_2.play("scroll")

#func _on_timer_timeout() -> void:
	#timer.stop()
	#if state:
		#animation_player.play("scroll")
		#state = false
	#else:
		#animation_player_2.stop()
		#animation_player_2.play("scroll")
		#state = true
	#timer.start(3)


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	animation_player.play("scroll")
	
		#animation_player.play("RESET")

func _on_animation_player_2_animation_finished(anim_name: StringName) -> void:
	animation_player_2.play("scroll")
		#animation_player_2.play("RESET")
