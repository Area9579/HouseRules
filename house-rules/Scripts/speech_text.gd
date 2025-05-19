class_name SpeechText
extends Node3D

@onready var sprite3D : Sprite3D = $Sprite3D
@onready var subViewport : SubViewport = $Sprite3D/SubViewport
@onready var richTextLabel : RichTextLabel = $Sprite3D/SubViewport/RichTextLabel

@onready var dialogueResources: Dictionary = {
	"introDialogue" : preload("res://Resources/Dialogue/introDialogue.tres"),
	"specialCardsDialogue" : preload("res://Resources/Dialogue/specialCardsDialogue.tres"),
	"denturesDialogue" : preload("res://Resources/Dialogue/denturesDialogue.tres"),
	"brickDialogue" : preload("res://Resources/Dialogue/brickDialogue.tres"),
	"winDialogue" : preload("res://Resources/Dialogue/winDialogue.tres"),
	"loseDialogue" : preload("res://Resources/Dialogue/loseDialogue.tres"),
	"endDialogue" : preload("res://Resources/Dialogue/endDialogue.tres")
}


var speedPerCharacter: float = 0.01 #0.08 -> change back once testing is over
var lineSpeed : float
var string : String
var isBeingRead: bool = false


func _ready() -> void:
	SignalBus.connect("readDialogueSignal", sendToReadDialogue)
	SignalBus.connect("resetReadDialogue", resetReadDialogue)


func _process(_delta: float) -> void:
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
		SignalBus.emit_signal("dialogueCompletedSignal")


func sendToReadDialogue(dialogueString : String):
	readDialogue(dialogueResources[dialogueString])


func resetReadDialogue(dialogueString : String):
	dialogueResources[dialogueString].setRead(false)
