extends Node3D

@onready var keyLabel: Label3D = $Label3D

@export var key: String


func _ready() -> void:
	Director.keyPressed.connect(keyIsVisible)
	Director.keyReleased.connect(keyIsNotVisible)
	keyLabel.text = key


func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.is_pressed():
		Director.keyPressed.emit(char(event.keycode))
	elif event is InputEventKey:
		Director.keyReleased.emit(char(event.keycode))


func keyIsVisible(_key):
	keyLabel.visible = true


func keyIsNotVisible(_key):
	keyLabel.visible = false
