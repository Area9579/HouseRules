extends Node

@warning_ignore("unused_signal") signal keyPressed(key: String)

@onready var quickTimeEvent = preload("res://Scenes/quick_time_event.tscn")

var fullscreen := false 

func _process(_delta):
	if Input.is_action_just_pressed("exit"):
		get_tree().quit()
	
	if Input.is_action_just_pressed("fullscreen"):
		if !fullscreen:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			fullscreen = true
		else:
			fullscreen = false
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	
	if Input.is_action_just_pressed('restart'):
		get_tree().reload_current_scene()

	#if Input.is_action_just_pressed("reset"):
		#var QTE = quickTimeEvent.instantiate()
		#get_tree().current_scene.add_child(QTE)
		
