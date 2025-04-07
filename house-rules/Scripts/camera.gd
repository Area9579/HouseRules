extends Camera3D

@export var mouseSensitivity: int 
@onready var rayCast: RayCast3D = $RayCast3D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var previous_collider
func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _process(_delta):
	cam_shake(_delta)
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
		rotation_degrees.x = clamp(rotation_degrees.x, -75, -15)
		rotation_degrees.y = clamp(rotation_degrees.y, -170, -30)
		rotation_degrees.z = clamp(rotation_degrees.z, 0, 0)
	
	

var trauma_x = 0
var truama_y = 0

func cam_shake(delta):
	h_offset += randf_range(-trauma_x,trauma_x) * .01
	v_offset += randf_range(-truama_y,truama_y) * .01
	trauma_x = move_toward(trauma_x, 0, delta)
	truama_y = move_toward(truama_y, 0, delta)
	h_offset = lerp(h_offset, 0.0, delta * 12)
	v_offset = lerp(v_offset, 0.0, delta * 12)

func add_trauma():
	$Timer.start(randf_range(.1,2))
	truama_y += randf_range(-.3,.3)
	randomize()
	trauma_x += randf_range(-.3,.3)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotate_y(clampf(event.relative.x, -30, 30) * -0.005 * mouseSensitivity)
		rotate_z(clampf(event.relative.y, -30, 30) * -0.005 * mouseSensitivity)
	
