extends Node3D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var animation_player_2: AnimationPlayer = $AnimationPlayer2
@onready var timer: Timer = $Timer

@onready var state : bool = false

func _ready() -> void:
	animation_player.play("scroll")
	animation_player_2.play("scroll")
