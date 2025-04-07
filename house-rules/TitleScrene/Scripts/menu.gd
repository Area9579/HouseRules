extends Node3D

@onready var sprite_3d: Sprite3D = $Sprite3D
var fading : bool = false

func fade_out():
	fading = true

func _process(delta: float) -> void:
	if fading: 
		var tween = get_tree().create_tween()
		tween.tween_property(sprite_3d, "modulate", Color(Color.WHITE, 0), 1)
