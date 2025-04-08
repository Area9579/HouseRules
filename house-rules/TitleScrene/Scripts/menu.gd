extends Node3D

@onready var label_3d: Label3D = $Label3D

var fading : bool = false

func fade_out():
	fading = true

func _process(delta: float) -> void:
	if fading: 
		var tween = get_tree().create_tween()
		tween.tween_property(label_3d, "modulate", Color(Color.WHITE, 0), 1)
