class_name SpeechText
extends Node3D

@onready var sprite3D : Sprite3D = $Sprite3D
@onready var subViewport : SubViewport = $Sprite3D/SubViewport
@onready var richTextLabel : RichTextLabel = $Sprite3D/SubViewport/RichTextLabel

var lineSpeed : float = 5.0
var string : String = "The quick brown fox jumped over the lazy dog..."

func _ready() -> void:
	DialogueManager.speechText = self


func _process(delta: float) -> void:
	#if Input.is_action_just_pressed("right"):
		#DialogueManager.readDialouge("Instructions")
	subViewport.size = Vector2(richTextLabel.size.x,richTextLabel.size.y)
	richTextLabel.position = Vector2.ZERO
	

func tweenText(text: String):
	changeVisiblility()
	richTextLabel.visible_ratio = 0
	richTextLabel.text = "[shake rate=20.0 level=5 connected=1]" + text + "[/shake]"
	var tween = get_tree().create_tween()
	tween.tween_property(richTextLabel, "visible_ratio", 1.0, lineSpeed)
	await get_tree().create_timer(lineSpeed + 0.8).timeout
	changeVisiblility()


func changeVisiblility():
	match richTextLabel.visible:
		true : richTextLabel.visible = false
		false : richTextLabel.visible = true
