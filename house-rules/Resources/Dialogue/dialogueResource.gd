class_name DialogueResource
extends Resource

@export var dialogue : Array


func getDialogue():
	return dialogue

func setRead(read : bool):
	dialogue[-1] = read
