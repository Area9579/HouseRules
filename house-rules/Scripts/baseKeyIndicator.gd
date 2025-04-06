class_name BaseKeyIndicator
extends Node3D

@onready var keyLabel: Label3D = $Label3D
@onready var timerLabel: Label3D = $TimerLabel

@export var key: String
@export_range(0, 5, 0.5) var mercyTimer: float = 0.5

var currentMercyTimer = 0
var releasedKey: bool = false


func _input(event: InputEvent) -> void:
	#Check to see if the button you pressed is equivalent to the key variable, then send a signal to director
	if event is InputEventKey and event.is_pressed() and key == OS.get_keycode_string(event.get_keycode_with_modifiers()):
		Director.keyPressed.emit(OS.get_keycode_string(event.get_keycode_with_modifiers()))
	#Check to see if the key you released is equivalent to the key variable, then send a signal to director
	elif event is InputEventKey and key == OS.get_keycode_string(event.get_keycode_with_modifiers()):
		Director.keyReleased.emit(OS.get_keycode_string(event.get_keycode_with_modifiers()))


func labelHalfOpacity(): #ok this one is pretty self explanatory
	keyLabel.modulate.a = 0.5
	timerLabel.modulate.a = 0.5


func updateTimerLabel(): #yeah I don't need to say much about this, just formatting
	timerLabel.text = str(int(currentMercyTimer * 100) / 100.0)
