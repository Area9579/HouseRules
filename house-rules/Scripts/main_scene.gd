extends Node3D

@onready var player_cam: Camera3D = $PlayerBody/PlayerCamera
@onready var player_cam_anim_player = player_cam.get_node("AnimationPlayer")
@onready var player_fade_anim_player = player_cam.get_node("FadeIn").get_child(0)
@onready var menu: Node3D = $Menu

func _ready():
	if !GameState.introPlayed:
		player_cam_anim_player.current_animation = "intro"
		GameState.introPlayed = true
	player_fade_anim_player.current_animation = "fade_in"

func _process(delta: float) -> void:
	if player_cam_anim_player.is_playing():
		if player_cam_anim_player.current_animation == "intro":
			if Input.is_action_just_released("left"):
				menu.fade_out()
				player_cam_anim_player.current_animation = "turning"
