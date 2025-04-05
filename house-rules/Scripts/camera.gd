extends Camera3D

@export var mouseSensitivity: int 

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _process(_delta):
	rotation_degrees.x = clamp(rotation_degrees.x, -50, 30)
	rotation_degrees.y = clamp(rotation_degrees.y, -160, -20)
	rotation_degrees.z = clamp(rotation_degrees.z, 0, 0)

func _input(event: InputEvent) -> void:
	if Input.is_action_pressed("right"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	elif event is InputEventMouseMotion:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		
		#uncomment this to try the wierd camera movement
		
		#if event.relative.x > 0:
			#rotate_y(3 * -0.005 * mouseSensitivity)
		#elif event.relative.x < 0:
			#rotate_y(3 * 0.005 * mouseSensitivity)
		#if event.relative.y > 0:
			#rotate_z(3 * -0.005 * mouseSensitivity)
		#elif event.relative.y < 0:
			#rotate_z(3 * 0.005 * mouseSensitivity)
		
		#comment this to try the other movement
		rotate_y(clampf(event.relative.x, -30, 30) * -0.005 * mouseSensitivity)
		rotate_z(clampf(event.relative.y, -30, 30) * -0.005 * mouseSensitivity)
	
