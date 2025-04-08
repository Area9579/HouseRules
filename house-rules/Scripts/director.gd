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
const e1 = preload("res://raw_assets/cardtextures/e1.jpg")
const e2 = preload("res://raw_assets/cardtextures/e2.jpg")
const e3 = preload("res://raw_assets/cardtextures/e3.jpg")
const E_4 = preload("res://raw_assets/cardtextures/e4.jpg")
const E_5 = preload("res://raw_assets/cardtextures/e5.jpg")
const E_6 = preload("res://raw_assets/cardtextures/e6.jpg")
const E_7 = preload("res://raw_assets/cardtextures/e7.jpg")
const E_8 = preload("res://raw_assets/cardtextures/e8.jpg")
const E_9 = preload("res://raw_assets/cardtextures/e9.jpg")
const E_10 = preload("res://raw_assets/cardtextures/e10.jpg")
const EK = preload("res://raw_assets/cardtextures/ek.png")
const H_1 = preload("res://raw_assets/cardtextures/h1.jpg")
const H_2 = preload("res://raw_assets/cardtextures/h2.jpg")
const H_3 = preload("res://raw_assets/cardtextures/h3.jpg")
const H_4 = preload("res://raw_assets/cardtextures/h4.jpg")
const H_5 = preload("res://raw_assets/cardtextures/h5.jpg")
const H_6 = preload("res://raw_assets/cardtextures/h6.jpg")
const H_7 = preload("res://raw_assets/cardtextures/h7.jpg")
const H_8 = preload("res://raw_assets/cardtextures/h8.jpg")
const H_9 = preload("res://raw_assets/cardtextures/h9.jpg")
const H_10 = preload("res://raw_assets/cardtextures/h10.jpg")
const HK = preload("res://raw_assets/cardtextures/hk.png")
const JB = preload("res://raw_assets/cardtextures/jb.png")
const JR = preload("res://raw_assets/cardtextures/jr.png")
const M_1 = preload("res://raw_assets/cardtextures/m1.jpg")
const M_2 = preload("res://raw_assets/cardtextures/m2.jpg")
const M_3 = preload("res://raw_assets/cardtextures/m3.jpg")
const M_4 = preload("res://raw_assets/cardtextures/m4.jpg")
const M_5 = preload("res://raw_assets/cardtextures/m5.jpg")
const M_6 = preload("res://raw_assets/cardtextures/m6.jpg")
const M_7 = preload("res://raw_assets/cardtextures/m7.jpg")
const M_8 = preload("res://raw_assets/cardtextures/m8.jpg")
const M_9 = preload("res://raw_assets/cardtextures/m9.jpg")
const M_10 = preload("res://raw_assets/cardtextures/m10.jpg")
const MK = preload("res://raw_assets/cardtextures/mk.png")
const R_1 = preload("res://raw_assets/cardtextures/r1.jpg")
const R_2 = preload("res://raw_assets/cardtextures/r2.jpg")
const R_3 = preload("res://raw_assets/cardtextures/r3.jpg")
const R_4 = preload("res://raw_assets/cardtextures/r4.jpg")
const R_5 = preload("res://raw_assets/cardtextures/r5.jpg")
const R_6 = preload("res://raw_assets/cardtextures/r6.jpg")
const R_7 = preload("res://raw_assets/cardtextures/r7.jpg")
const R_8 = preload("res://raw_assets/cardtextures/r8.jpg")
const R_9 = preload("res://raw_assets/cardtextures/r9.jpg")
const R_10 = preload("res://raw_assets/cardtextures/r10.jpg")
const RK = preload("res://raw_assets/cardtextures/rk.png")

var z
func _ready() -> void:
	
	var dir = DirAccess.open("res://raw_assets/cardtextures/")
	dir.list_dir_begin()
	z = [e1, e2, e3, E_4, E_5, E_6, E_7, E_8, E_9, E_10, EK, H_1, H_2, H_3, H_4, H_5, H_6, H_7, H_8, H_9, H_10, HK, JB, JR, M_1, M_2, M_3, M_4, M_5, M_6, M_7, M_8, M_9, M_10, MK, R_1, R_2, R_3, R_4, R_5, R_6, R_7, R_8, R_9, R_10, RK]
	
	for file in z:
		var image_texture = ImageTexture.new()
		
		var texture_to_place = image_texture.create_from_image(file)
		var index = z.find(file)
		
		match file:
			0:
				texture_to_place.set_name("e1")
			1:
				texture_to_place.set_name("e2")
			2:
				texture_to_place.set_name("e3")
			3:
				texture_to_place.set_name("e4")
			4:
				texture_to_place.set_name("e5")
			5:
				texture_to_place.set_name("e6")
			6:
				texture_to_place.set_name("e7")
			7:
				texture_to_place.set_name("e8")
			8:
				texture_to_place.set_name("e9")
			9:
				texture_to_place.set_name("e10")
			10:
				texture_to_place.set_name("ek")
		#texture_to_place.set_name(file.left(-4))
		#print(texture_to_place)
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
		
