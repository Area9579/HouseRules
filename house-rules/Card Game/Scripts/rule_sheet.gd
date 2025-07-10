class_name RuleSheet
extends Node3D

@onready var outline : MeshInstance3D = $Outline
var has_mouse : bool = false
var active : bool = false
var posTween : Tween
var rotTween : Tween


func _process(delta: float) -> void:
	if has_mouse:
		highlight()
	else:
		unhighlight()
		
	if active:
		activePosition()
	else:
		idlePosition()
		
	if Input.is_action_just_pressed("left") and has_mouse:
		if active:
			active = false
		else:
			active = true

func activePosition():
	posTween = get_tree().create_tween()
	rotTween = get_tree().create_tween()
	posTween.tween_property(self, "position", Vector3(-4.687, 1.415, -2.979), 0.5)
	rotTween.tween_property(self, "rotation_degrees", Vector3(-90, 145, 0), 0.5)
	#rotation_degrees = lerp(rotation_degrees, Vector3(-90, 145, 0), 1)
	#position = lerp(position, Vector3(-4.687, 1.415, -2.979), 1)


func idlePosition():
	posTween = get_tree().create_tween()
	rotTween = get_tree().create_tween()
	posTween.tween_property(self, "position", Vector3(-4.6, 1.015, -3.34), 0.5)
	rotTween.tween_property(self, "rotation_degrees", Vector3(0, 90, 0), 0.5)
	#rotation_degrees = lerp(rotation_degrees, Vector3(0, 90, 0), 1)
	#position = lerp(position, Vector3(-4.6, 1.015, -3.34), 1)


func highlight():
	outline.visible = true


func unhighlight():
	outline.visible = false
