class_name KeyIndicator
extends Node3D

@onready var keyLabel: Label3D = $Label3D
@onready var timerLabel: Label3D = $TimerLabel

@export var key: String
@export_range(0, 5, 0.5) var mercyTimer: float = 0.5
@export var cardPlacement: CardPlacement

var currentMercyTimer = 0
var releasedKey: bool = true


func _ready() -> void:
	#connect both of the signals for pressing and releasing keys
	Director.keyPressed.connect(keyIsPressed)
	Director.keyReleased.connect(keyIsReleased)
	#both of these are setting the text for the indicators, this will prob be changed later
	keyLabel.text = key
	timerLabel.text = str(mercyTimer)


func _process(delta: float) -> void:
	#if a key is released, then decrease the timer
	if releasedKey:
		if currentMercyTimer > 0:
			currentMercyTimer -= delta
		else:
			setLabelsInvisible()
			cardPlacement.remove_card()
	
	updateTimerLabel()


func _input(event: InputEvent) -> void:
	#Check to see if the button you pressed is equivalent to the key variable, then send a signal to director
	if event is InputEventKey and event.is_pressed() and key == OS.get_keycode_string(event.get_keycode_with_modifiers()):
		Director.keyPressed.emit(OS.get_keycode_string(event.get_keycode_with_modifiers()))
	#Check to see if the key you released is equivalent to the key variable, then send a signal to director
	elif event is InputEventKey and key == OS.get_keycode_string(event.get_keycode_with_modifiers()):
		Director.keyReleased.emit(OS.get_keycode_string(event.get_keycode_with_modifiers()))


func keyIsPressed(signalKey):
	#resets the timer, and turns the labels to be visible when key is pressed
	if signalKey == key:
		currentMercyTimer = mercyTimer
		releasedKey = false
		keyLabel.modulate.a = 1
		timerLabel.modulate.a = 1


func keyIsReleased(signalKey):
	#change bool to state that a key has been released
	if signalKey == key:
		releasedKey = true


func setLabelsInvisible(): #ok this one is pretty self explanatory
	keyLabel.modulate.a = 0.5
	timerLabel.modulate.a = 0.5


func updateTimerLabel(): #yeah I don't need to say much about this, just formatting
	timerLabel.text = str(int(currentMercyTimer * 100) / 100.0)
