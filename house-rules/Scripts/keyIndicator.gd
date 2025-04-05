extends Node3D

@onready var keyLabel: Label3D = $Label3D
@onready var timerLabel: Label3D = $TimerLabel

@export var key: String
@export_range(0, 5, 0.5) var mercyTimer: float = 0.5

var currentMercyTimer = 0
var releasedKey: bool = true

func _ready() -> void:
	Director.keyPressed.connect(keyIsVisible)
	Director.keyReleased.connect(releaseKey)
	keyLabel.text = key
	timerLabel.text = str(mercyTimer)


func _process(delta: float) -> void:
	if releasedKey:
		if currentMercyTimer > 0:
			currentMercyTimer -= delta
		else:
			keyIsNotVisible()
	
	updateTimerLabel()



func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.is_pressed() and key == OS.get_keycode_string(event.get_keycode_with_modifiers()):
		Director.keyPressed.emit(OS.get_keycode_string(event.get_keycode_with_modifiers()))
	elif event is InputEventKey and key == OS.get_keycode_string(event.get_keycode_with_modifiers()):
		Director.keyReleased.emit(OS.get_keycode_string(event.get_keycode_with_modifiers()))


func keyIsVisible(signalKey):
	if signalKey == key:
		releasedKey = false
		currentMercyTimer = mercyTimer
		keyLabel.visible = true
		timerLabel.visible = true


func keyIsNotVisible():
	keyLabel.visible = false
	timerLabel.visible = false


func releaseKey(signalKey):
	if signalKey == key:
		releasedKey = true


func updateTimerLabel():
	timerLabel.text = str(int(currentMercyTimer * 100) / 100.0)
