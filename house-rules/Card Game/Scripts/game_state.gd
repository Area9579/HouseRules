extends Node

@onready var board
@onready var item_spawner

var introPlayed: bool = false #get rid of this later

enum States {
	player_draw, player_main, player_end,
	lady_draw, lady_main, lady_end,
	idle, item_event, fall_event,
	dentures, brick, severed_hand
	}

enum Stages {
	stage_1, stage_2
}

var stage = Stages.stage_1
var nextStage = Stages.stage_2

var currentState

var bricked_wait = 0

@export var ray_pickable_state = false


func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("zoom"):
		changePlayerState(States.player_draw)

func _ready() -> void:
	
	## connect all of the signals from the signal bus
	
	SignalBus.connect("changeStage", changeStage)
	SignalBus.connect("changePlayerState", sendToChangePlayerState)
	SignalBus.connect("changeLadyState", sendToChangeLadyState)
	SignalBus.connect("changeItemState", sendToChangeItemState)
	SignalBus.connect("getPlayerState", sendCurrentPlayerState)


func changePlayerState(changeState):
	if board == null or item_spawner == null: #get rid of this once it doesn't need to depend on board
		return
	
	match changeState:
		States.player_draw:
			currentState = States.player_draw
			
			bricked_wait -= 1
			if bricked_wait == 0:
				board.lady_reset()
			bricked_wait = max(0, bricked_wait)
			
			if board.drawing == false:
				board.play_draw_sound(.5)
				board.draw_card()
				changePlayerState(States.player_main)
			
		States.player_main:
			currentState = States.player_main
			
			for card_placement in board.left_hand.hand_card_organizer.get_children():
				if card_placement.card == null and card_placement:
					changePlayerState(States.player_end)
					break
			
			ray_pickable_state = true
			set_ray_pickable_on_card_placements(ray_pickable_state)
			ray_pickable_state = false
			
		States.player_end:
			currentState = States.player_end
			
			if bricked_wait == 0:
				SignalBus.emit_signal("readDialogueSignal", "specialCardsDialogue")
				
				set_ray_pickable_on_card_placements(ray_pickable_state)

				board.check_winner()
				
				changePlayerState(States.idle)
				changeLadyState(States.lady_draw)
			else:
				changePlayerState(States.player_draw)
			
		States.idle: # used as a pause or wait state, where nothing is done
			pass


func changeLadyState(changeState):
	if board == null or item_spawner == null: #get rid of this once it doesn't need to depend on board
		return
	
	match changeState:
		States.lady_draw:
			currentState = States.lady_draw
			
			board.lady_draw()
			await SignalBus.ladyAnimationComplete

			changeLadyState(States.lady_main)
		
		States.lady_main:
			currentState = States.lady_main

			board.lady_main()

			await SignalBus.ladyAnimationComplete
			
			item_spawner.item_event_triggered()
			changeLadyState(States.lady_end)
			
		States.lady_end:
			currentState = States.lady_end

			board.lady_end()

			await SignalBus.ladyAnimationComplete

			board.check_winner()
			
			changeLadyState(States.idle)
			changePlayerState(States.player_draw)
		
		States.idle: # used as a pause or wait state, where nothing is done
			pass


func changeItemState(changeState):
	if currentState != States.player_main: return #check to see if you should be able to use an item
	
	match changeState:
		
		States.severed_hand: #this is currently unused
			for i in 5:
				board.draw_card()
			changePlayerState(States.player_end)
		
		States.dentures:
			changePlayerState("idle") #don't allow player to do anything else while the state is playing
			board.rowSelectionMode = true # this will set off the selection mode code in board (temperary)
		
		States.brick:
			changePlayerState("idle") #don't allow player to do anything else while the state is playing

			board.run_brick_code()
			bricked_wait = 3

			await SignalBus.ladyAnimationComplete # wait for the lady's animation to finish

			changePlayerState(States.player_draw) # go to the player's draw state


## we will likely add some more stages later, so the dialogue and such are subject to change
func changeStage():

	match stage:
	
		Stages.stage_1:
			changePlayerState("idle")
			changeLadyState("idle")

			nextStage = Stages.stage_2
			item_spawner.threshold = 11 #this doesn't work, have something signal which stage it is on start
			
			SignalBus.emit_signal("readDialogueSignal", "winDialogue") # read dialogue for winning the stage
			await SignalBus.dialogueCompletedSignal # wait for dialogue to complete
			
			changePlayerState("player_draw") # set state for the beginning of the stage

		Stages.stage_2:
			changePlayerState("idle")
			changeLadyState("idle")
			
			nextStage = Stages.stage_2 # this is a temperary measure to allow you to keep replaying the second stage
			item_spawner.threshold = 8
			
			SignalBus.emit_signal("readDialogueSignal", "endDialogue") # read current end dialogue
			await SignalBus.dialogueCompletedSignal # wait for dialogue to complete
			
			SignalBus.emit_signal("resetReadDialogue", "endDialogue") # this is a temperary measure to allow you to keep replaying the second stage
			
			changePlayerState("player_draw") # set state for the beginning of the stage
	
	board.clear_board()
	
	
	stage = nextStage


## this function converts a string into a enum value and then returns it

func stringToEnumValueConverter(enumValueString : String):
	for enumValue in range(0, States.size()):
		if States.keys()[enumValue] == enumValueString:
			return (States.values()[enumValue])

## this function converts a enum value into a string and then returns it

func enumValueToStringConverter(enumValueInt : int):
	for enumValue in range(0, States.size()):
		if States.values()[enumValue] == enumValueInt:
			return (States.keys()[enumValue])


## the three function below just convert and then send the correct states to thier respective functions
## there is probably a better way to do this but it works for now

func sendToChangePlayerState(stringToConvert : String):
	var convertedString = stringToEnumValueConverter(stringToConvert)
	changePlayerState(convertedString)


func sendToChangeLadyState(stringToConvert : String):
	var convertedString = stringToEnumValueConverter(stringToConvert)
	changeLadyState(convertedString)


func sendToChangeItemState(stringToConvert : String):
	var convertedString = stringToEnumValueConverter(stringToConvert)
	changeItemState(convertedString)


func set_ray_pickable_on_card_placements( state ):
	for clickable_area in board.get_node("LadyCardOrganizer").get_children():
		clickable_area.get_node("Area3D").set_ray_pickable(state)
	for clickable_area in board.get_node("PlayerCardOrganizer").get_children():
		clickable_area.get_node("Area3D").set_ray_pickable(state)
	for clickable_area in board.get_node("PlayerCardOrganizer").get_children():
		clickable_area.get_node("Area3D").set_ray_pickable(state)


func sendCurrentPlayerState():
	SignalBus.emit_signal("sendPlayerState", enumValueToStringConverter(currentState))
