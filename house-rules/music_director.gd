extends Node
@onready var train: AudioStreamPlayer = $Train
@onready var train_2: AudioStreamPlayer = $Train2


func _on_switcher_train_timeout() -> void:
	if train.playing: train_2.play()
	elif train_2.playing: train.play()
