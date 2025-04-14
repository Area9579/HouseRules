class_name DialogueResource
extends Resource

@export var dialogue : Array

var dialogueDict: Dictionary = {
	"Instructions" : 
	["Here is how the game is played...",
	"I use house rules so they may not be familiar...",
	"Basically I made this shit up...",
	"Any object that topples onto our table may be used",
	"Often to your benefit...",
	"...",
	"...",
	"My eyes are up here...", 
	"Anyways...",
	"Each turn you can play a card using LMB",
	"or discard a card with RMB...",
	"the goal is to have the most points at the end of the round...",
	"Match cards in a column to multiply them",
	"and discarding one will erase",
	"all cards of the same value on the board...",
	"The round ends when one person's board is full",
	"I hope that makes sense to you...",
	"My brain is awful foggy these days",
	false],
	
	"SpecialCards":
	["This deck was a gift to me,",
	"and it's very special.",
	"It has two special cards",
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
	"Let's say... it eats a whole row!",
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
	["Oh my, it looks like",
	"we've run out of time!",
	"I hope I can play with you",
	"again sometime.",
	false]
}

func getDialogue():
	return dialogue

func setRead(read : bool):
	dialogue[-1] = read
