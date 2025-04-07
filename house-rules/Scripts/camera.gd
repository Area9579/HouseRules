extends Camera3D

@export var mouseSensitivity: int 
@onready var rayCast: RayCast3D = $RayCast3D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var previous_collider
func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _process(_delta):
	if rayCast.is_colliding() and rayCast.get_collider().get_parent() is CardPlacement:
		if rayCast.get_collider().owner.get_parent().name == "HandCardOrganizer" or rayCast.get_collider().owner.get_parent().name == "PlayerCardOrganizer":
			rayCast.get_collider().get_parent().highlight()
	elif rayCast.is_colliding() and rayCast.get_collider().get_parent().get_parent() is Item:
		rayCast.get_collider().owner.has_mouse = true
		previous_collider = rayCast.get_collider()
	
	if rayCast.is_colliding() == false and previous_collider != null:
		previous_collider.owner.has_mouse = false
		previous_collider = null
	
	if animation_player.current_animation != "turning" or animation_player.current_animation != "intro":
		rotation_degrees.x = clamp(rotation_degrees.x, -65, 0)
		rotation_degrees.y = clamp(rotation_degrees.y, -150, -30)
		rotation_degrees.z = clamp(rotation_degrees.z, 0, 0)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotate_y(clampf(event.relative.x, -30, 30) * -0.005 * mouseSensitivity)
		rotate_z(clampf(event.relative.y, -30, 30) * -0.005 * mouseSensitivity)
	
