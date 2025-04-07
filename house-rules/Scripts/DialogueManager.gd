extends Node

@onready var speechText : SpeechText
var isBeingRead: bool = false

var dialogueDict: Dictionary = {
	"Instructions" : 
	["Here is how the game is played...",
	"It's house rules so you may not be familiar...",
	"Basically I made that shit up... anyways",
	"Each turn you can play a card using",
	"left mouse button",
	"or discard a card with right mouse button",
	"the goal is to have more points",
	"at the end of the round",
	"you get points equal to the value on the card",
	"multiples of a card in a row will",
	"mulitpy by how many there are in that row",
	"discarding a card will get rid of all cards",
	"of the same value on the board",
	"the round ends when one person's board is full",
	"Good luck, f r i e n d ...",
	false]
	
}

func readDialouge( dialogueChoice : String ):
	if dialogueDict[dialogueChoice][-1] == true:
		print("This dialogue has already been read")
		return
	else:
		if isBeingRead == false:
			isBeingRead = true
			for line in dialogueDict[dialogueChoice].size() - 1:
				speechText.tweenText(dialogueDict[dialogueChoice][line])
				await get_tree().create_timer(speechText.lineSpeed + 1).timeout
			dialogueDict[dialogueChoice][-1] = true
			isBeingRead = false
