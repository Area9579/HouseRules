extends Camera3D

@export var mouseSensitivity: int 
@onready var rayCast: RayCast3D = $RayCast3D

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _process(_delta):
	if rayCast.is_colliding() and rayCast.get_collider().get_parent() is CardPlacement:
		rayCast.get_collider().get_parent().highlight()
	elif rayCast.is_colliding() and rayCast.get_collider().get_parent() is Item:
		rayCast.get_collider().get_parent().has_mouse = true
	
	rotation_degrees.x = clamp(rotation_degrees.x, -65, 0)
	rotation_degrees.y = clamp(rotation_degrees.y, -150, -30)
	rotation_degrees.z = clamp(rotation_degrees.z, 0, 0)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotate_y(clampf(event.relative.x, -30, 30) * -0.005 * mouseSensitivity)
		rotate_z(clampf(event.relative.y, -30, 30) * -0.005 * mouseSensitivity)
	
