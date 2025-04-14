class_name SpeechText
extends Node3D

@export var dialogueResource: DialogueResource

@onready var sprite3D : Sprite3D = $Sprite3D
@onready var subViewport : SubViewport = $Sprite3D/SubViewport
@onready var richTextLabel : RichTextLabel = $Sprite3D/SubViewport/RichTextLabel

@onready var testDialogue = preload("res://Resources/Dialogue/testDialogue.tres")
@onready var introDialogue = preload("res://Resources/Dialogue/introDialogue.tres")
@onready var specialCardsDialogue = preload("res://Resources/Dialogue/specialCardsDialogue.tres")
@onready var denturesDialogue = preload("res://Resources/Dialogue/denturesDialogue.tres")
@onready var brickDialogue = preload("res://Resources/Dialogue/brickDialogue.tres")
@onready var winDialogue = preload("res://Resources/Dialogue/winDialogue.tres")
@onready var loseDialogue = preload("res://Resources/Dialogue/loseDialogue.tres")
@export var endDialogue = preload("res://Resources/Dialogue/endDialogue.tres")


var speedPerCharacter: float = 0.08
var lineSpeed : float
var string : String
var isBeingRead: bool = false


func _ready() -> void:
	SignalBus.connect("testSignal", readTestDialogue)
	SignalBus.connect("introSignal", readIntroDialogue)
	SignalBus.connect("specialCardsSignal", readSpecialCardsDialogue)
	SignalBus.connect("denturesSignal", readDenturesDialogue)
	SignalBus.connect("brickSignal", readBrickDialogue)
	SignalBus.connect("winSignal", readWinDialogue)
	SignalBus.connect("loseSignal", readLoseDialogue)
	SignalBus.connect("endSignal", readEndDialogue)


func _process(delta: float) -> void:
	subViewport.size = Vector2(richTextLabel.size.x,richTextLabel.size.y)
	richTextLabel.position = Vector2.ZERO


func tweenText(text: String):
	lineSpeed = text.length() * speedPerCharacter
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


func readDialogue(dialogueChoice : DialogueResource):
	if dialogueChoice.getDialogue()[-1] == true: #check to see if the dialogue has already been read
		return
	if isBeingRead == false:
		isBeingRead = true
		
		for line in range(0,dialogueChoice.getDialogue().size() - 1): #go through even line in the dialogue except for the bool
			tweenText(dialogueChoice.getDialogue()[line]) #read the line of text
			await get_tree().create_timer(lineSpeed + 1).timeout #wait for the line to finish
		
		dialogueChoice.setRead(true) #set the dialogue as having been read
		
		isBeingRead = false


func readTestDialogue():
	readDialogue(testDialogue)


func readIntroDialogue():
	readDialogue(introDialogue)


func readSpecialCardsDialogue():
	readDialogue(specialCardsDialogue)


func readDenturesDialogue():
	readDialogue(denturesDialogue)


func readBrickDialogue():
	readDialogue(brickDialogue)


func readWinDialogue():
	readDialogue(winDialogue)


func readLoseDialogue():
	readDialogue(loseDialogue)


func readEndDialogue():
	readDialogue(endDialogue)
