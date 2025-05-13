extends Node3D

@onready var label_3d: Label3D = $Label3D

var fading : bool = false

func fade_out():
	fading = true

func _process(_delta: float) -> void:
	if fading: 
		var tween = get_tree().create_tween()
		tween.tween_property(label_3d, "modulate", Color(Color.WHITE, 0), 1)
		tween.tween_property(label_3d, "outline_modulate", Color(Color.BLACK, 0), 1)
