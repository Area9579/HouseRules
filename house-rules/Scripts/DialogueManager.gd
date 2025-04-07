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
	false],
	
	"SpecialCards":
	["This game has two special cards",
	"The King and the Joker",
	"The King, when discarded will destroy",
	"all cards of the same Suit",
	"The Joker however, destorys every card",
	"of the same color",
	false],
	
	
	"Dentures" :
	["Oh goodness me!",
	"That must be where it went",
	"Well I suppose that we can make use of it",
	"Let's say... it takes out a whole row",
	"Both mine and yours included",
	false],
	
	
	"Brick" : 
	["Oh, I guess we can use that... but",
	"...what are you goint to doing with it?",
	false],
	
	
	"Win":
	["Well done, well done!",
	"But how about we spice it up a little, hmm?",
	false],
	
	
	"Lose":
	["I win!",
	"Aww, that was well played",
	"It would be a shame to end now though",
	"How about another round?",
	false],
	
	
	"End":
	["I commend you, truly",
	"But you didn't really think it would end",
	"l i k e  t h i s  d i d  y o u. . ?",
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
