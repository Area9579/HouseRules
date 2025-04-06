extends Node3D
var spawn_threshold : int = 2

func _ready() -> void:
	get_tree().get_node("Board").connect("turn_passed", turn_passed())

func turn_passed():
	var random_num = randi_range(0, 10)
	
	if random_num < spawn_threshold:
		# item spawn
		pass
	else:
		# no item spawn
		pass
