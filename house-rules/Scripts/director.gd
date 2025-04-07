extends Node

@warning_ignore("unused_signal") signal keyPressed(key: String)

@onready var quickTimeEvent = preload("res://Scenes/quick_time_event.tscn")

var fullscreen := false 
var textures = []

static func load_asset(path : String) -> Resource:
	if OS.has_feature("export"):
		# Check if file is .remap
		if not path.ends_with(".remap"):
			return load(path)
		# Open the file
		var __config_file = ConfigFile.new()
		__config_file.load(path)

		# Load the remapped file
		var __remapped_file_path = __config_file.get_value("remap", "path")
		__config_file = null
		return load(__remapped_file_path)
	else:
		return load(path)

func _ready() -> void:
	
	var dir = DirAccess.open("res://raw_assets/cardtextures/")
	dir.list_dir_begin()
	
	for file in dir.get_files():
		var index = dir.get_files().find(file) % 2
		if index == 0:
			var i = load_asset(dir.get_current_dir() + "/" + file)
			if i is Image:
				var image_texture = ImageTexture.new()
				
				var texture_to_place = image_texture.create_from_image(i)
				texture_to_place.set_name(file.left(-4))
				textures += [texture_to_place]
				
				
	
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
		
