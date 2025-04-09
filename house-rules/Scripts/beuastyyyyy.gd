extends Node3D
@onready var blinktimer: Timer = $blinktimer
const REGULAR = preload("res://raw_assets/regular.tres")
const TALK = preload("res://raw_assets/talk.tres")
const BLINK = preload("res://raw_assets/blink.tres")
@onready var look_at: Marker3D = $Armature/Skeleton3D/LookAt

@onready var head_mesh: MeshInstance3D = $Armature/Skeleton3D/Icosphere_002

var talking = false
var sin_talk = 0
func _process(delta: float) -> void:
	if talking:
		sin_talk += delta * 30
		if sin(sin_talk) > 0: head_mesh.set_surface_override_material(0, REGULAR)
		else: head_mesh.set_surface_override_material(0, TALK)

func set_stop_talk():
	head_mesh.set_surface_override_material(0, REGULAR)
	talking = false
	

func _on_blinktimer_timeout() -> void:
	blinktimer.start(randf_range(1.0,10.0))
	
	head_mesh.set_surface_override_material(0, BLINK)
	await get_tree().create_timer(.1).timeout
	head_mesh.set_surface_override_material(0, REGULAR)
