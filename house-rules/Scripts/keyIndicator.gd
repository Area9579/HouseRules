extends Node3D

@onready var keyLabel: Label3D = $Label3D

@export var key: String
@export_range(0,5,0.5) var mercyTimer: float

var currentMercyTimer = 0

func _ready() -> void:
	Director.keyPressed.connect(keyIsVisible)
	Director.keyReleased.connect(keyIsNotVisible)
	keyLabel.text = key


func _process(delta: float) -> void:
	if currentMercyTimer > 0:
		currentMercyTimer -= delta
	else:
		currentMercyTimer = mercyTimer



func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.is_pressed() and key == OS.get_keycode_string(event.get_keycode_with_modifiers()):
		print(OS.get_keycode_string(event.get_keycode_with_modifiers()))
		Director.keyPressed.emit(OS.get_keycode_string(event.get_keycode_with_modifiers()))
	elif event is InputEventKey and key == OS.get_keycode_string(event.get_keycode_with_modifiers()):
		Director.keyReleased.emit(OS.get_keycode_string(event.get_keycode_with_modifiers()))


func keyIsVisible(signalKey):
	if signalKey == key:
		keyLabel.visible = true


func keyIsNotVisible(signalKey):
	if signalKey == key:
		keyLabel.visible = false
