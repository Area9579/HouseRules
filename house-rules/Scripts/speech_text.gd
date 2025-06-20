class_name SpeechText
extends Node3D

@onready var sprite3D : Sprite3D = $Sprite3D
@onready var subViewport : SubViewport = $Sprite3D/SubViewport
@onready var richTextLabel : RichTextLabel = $Sprite3D/SubViewport/RichTextLabel
@onready var lineTimer : Timer = $LineTimer
@onready var textTimer : Timer = $TextTimer
@onready var dialogueResources: Dictionary = {
	"introDialogue" : preload("res://Resources/Dialogue/introDialogue.tres"),
	"specialCardsDialogue" : preload("res://Resources/Dialogue/specialCardsDialogue.tres"),
	"denturesDialogue" : preload("res://Resources/Dialogue/denturesDialogue.tres"),
	"brickDialogue" : preload("res://Resources/Dialogue/brickDialogue.tres"),
	"winDialogue" : preload("res://Resources/Dialogue/winDialogue.tres"),
	"loseDialogue" : preload("res://Resources/Dialogue/loseDialogue.tres"),
	"endDialogue" : preload("res://Resources/Dialogue/endDialogue.tres")
}

var textTween : Tween

var speedPerCharacter: float = 0.08
var lineSpeed : float
var string : String
var isBeingRead: bool = false


func _ready() -> void:
	SignalBus.connect("readDialogueSignal", sendToReadDialogue)
	SignalBus.connect("resetReadDialogue", resetReadDialogue)


func _process(_delta: float) -> void:
	subViewport.size = Vector2(richTextLabel.size.x,richTextLabel.size.y)
	richTextLabel.position = Vector2.ZERO


func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("skip"):
		skipDialogue()


func tweenText(text: String):
	lineSpeed = text.length() * speedPerCharacter
	changeVisiblility( true )
	richTextLabel.visible_ratio = 0
	richTextLabel.text = "[shake rate=20.0 level=5 connected=1]" + text + "[/shake]"
	textTween = get_tree().create_tween()
	textTween.tween_property(richTextLabel, "visible_ratio", 1.0, lineSpeed)
	
	textTimer.wait_time = lineSpeed + 0.8 #set the time for the timer
	textTimer.start() #start the timer
	await textTimer.timeout #wait for the timer to finish
	
	changeVisiblility( false )


func changeVisiblility(visibility : bool):
	match visibility:
		true : richTextLabel.visible = true
		false : richTextLabel.visible = false


func readDialogue(dialogueChoice : DialogueResource):
	if dialogueChoice.getDialogue()[-1] == true: #check to see if the dialogue has already been read
		return
	if !isBeingRead:
		isBeingRead = true
		
		for line in range(0,dialogueChoice.getDialogue().size() - 1): #go through even line in the dialogue except for the bool
			if !isBeingRead: #this checks to see if the dialogue has been skipped
				break
			
			tweenText(dialogueChoice.getDialogue()[line]) #read the line of text
			lineTimer.wait_time = lineSpeed + 1
			lineTimer.start()
			await lineTimer.timeout
		
		dialogueChoice.setRead(true) #set the dialogue as having been read
		
		isBeingRead = false
		SignalBus.emit_signal("dialogueCompletedSignal")


func skipDialogue():
	if textTween == null: return
	
	isBeingRead = false
	
	textTween.kill() #stop the text from tweening
	textTimer.emit_signal("timeout") #signal the timer to end
	lineTimer.emit_signal("timeout") #signal the timer to end


func sendToReadDialogue(dialogueString : String):
	readDialogue(dialogueResources[dialogueString])


func resetReadDialogue(dialogueString : String):
	dialogueResources[dialogueString].setRead(false)
