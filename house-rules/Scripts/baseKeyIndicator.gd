class_name BaseKeyIndicator
extends Node3D

@onready var keyLabel: Label3D = $Label3D
@onready var timerLabel: Label3D = $TimerLabel

@export var key: String
@export_range(0, 10, 1) var mercyTimer

var currentMercyTimer = 0
var keyIsPressed: bool


func _input(event: InputEvent) -> void:
	#Check to see if the button you pressed is equivalent to the key variable, then send a signal to director
	if event is InputEventKey and event.is_pressed() and key == OS.get_keycode_string(event.get_keycode_with_modifiers()):
		Director.keyPressed.emit(OS.get_keycode_string(event.get_keycode_with_modifiers()))


func pressedKey(signalKey):
	if signalKey == key:
		keyIsPressed = true
		labelFullOpacity()


func labelHalfOpacity(): #ok this one is pretty self explanatory
	keyLabel.modulate.a = 0.5
	timerLabel.modulate.a = 0.5


func labelFullOpacity():
	keyLabel.modulate.a = 1
	timerLabel.modulate.a = 1


func updateTimerLabel(): #yeah I don't need to say much about this, just formatting
	timerLabel.text = str(int(currentMercyTimer * 100) / 100.0)
