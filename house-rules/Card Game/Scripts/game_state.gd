extends Node

@onready var board
@onready var item_spawner

var introPlayed: bool = false #get rid of this later

enum States {
	player_draw, player_main, player_end,
	lady_draw, lady_main, lady_end,
	win, lose, item_event, fall_event,
	dentures, brick, severed_hand
	}

enum Stages {
	stage_1, stage_2
}

var stage = Stages.stage_1
var nextStage = Stages.stage_2

var currentState

var bricked_wait = 0

@export var state = States.player_draw
@export var next_state = States.player_main
@export var ray_pickable_state = false

signal turn_pass

func _ready() -> void:
	connect("turn_pass", _turn_pass)
	SignalBus.connect("changeStage", changeStage)
	SignalBus.connect("changePlayerState", sendToChangePlayerState)
	SignalBus.connect("changeLadyState", sendToChangeLadyState)
	SignalBus.connect("changeItemState", sendToChangeItemState)
	
func _turn_pass(): 
	return true


func _process(delta: float) -> void:
	if board == null or item_spawner == null:
		return

	#TODO: match state -> needs to be moved to a signal
	#match state:
		#States.player_draw:
			#
			#bricked_wait -= 1
			#if bricked_wait == 0:
				#board.lady_reset()
			#bricked_wait = max(0, bricked_wait)
			#next_state = States.player_main
			#
			#if board.drawing == false:
				#board.play_draw_sound(.5)
				#board.draw_card()
				#state = next_state
			#
		#States.player_main:
			#next_state = States.player_end
			#
			#for card_placement in board.left_hand.hand_card_organizer.get_children():
				#if card_placement.card == null and card_placement:
					#state = next_state
					#break
			#
			#ray_pickable_state = true
			#set_ray_pickable_on_card_placements(ray_pickable_state)
			#ray_pickable_state = false
			#
		#States.player_end: #TODO come back and make item event triggered only
			#if bricked_wait == 0:
				#SignalBus.emit_signal("readDialogueSignal", "specialCardsDialogue")
				#
				#next_state = States.lady_draw
				 ##gurentee
				#set_ray_pickable_on_card_placements(ray_pickable_state)
				#state = next_state
				#board.check_winner()
			#else:
				#next_state = States.player_draw
				#state = next_state
		
		#States.lady_draw:
			#next_state = States.lady_main
			#state = null
			#
			#board.lady_draw()
			#await self.turn_pass
			#
			#state = next_state
		#
		#States.lady_main:
			#next_state = States.lady_end
			#state = null
			#board.lady_main()
			#await self.turn_pass
			#state = next_state
			#item_spawner.item_event_triggered()
			#
		#States.lady_end:
			#state = null
			#board.lady_end()
			#next_state = States.player_draw
			#await self.turn_pass
			#state = next_state
			#board.check_winner()
			
		
		#States.win:
			#next_state = null
		#States.lose:
			#next_state = null
		#
		#States.item_event:
			#pass
		#States.fall_event:
			#pass
		#
		#States.severed_hand:
			#for i in 5:
				#board.draw_card()
			#state = next_state
		#
		#States.dentures:
			#board.run_dentures_code()
		#
		#States.brick:
			#state = null
			#board.run_brick_code()
			#bricked_wait = 3
			#await self.turn_pass
			#state = States.player_draw
	
	
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
			
			#next_state = States.player_end
			
			for card_placement in board.left_hand.hand_card_organizer.get_children():
				if card_placement.card == null and card_placement:
					changePlayerState(States.player_end)
					break
			
			ray_pickable_state = true
			set_ray_pickable_on_card_placements(ray_pickable_state)
			ray_pickable_state = false
			
		States.player_end: #TODO come back and make item event triggered only <---- what does this even mean lmao (phoenix)
			currentState = States.player_end
			
			if bricked_wait == 0:
				SignalBus.emit_signal("readDialogueSignal", "specialCardsDialogue")
				
				 #gurentee
				set_ray_pickable_on_card_placements(ray_pickable_state)
				#state = next_state
				board.check_winner()
				
				changeLadyState(States.lady_draw)
			else:
				changePlayerState(States.player_draw)


func changeLadyState(changeState):
	if board == null or item_spawner == null: #get rid of this once it doesn't need to depend on board
		return
	
	match changeState:
		States.lady_draw:
			currentState = States.lady_draw
			#next_state = States.lady_main
			#state = null
			
			board.lady_draw()
			await SignalBus.ladyAnimationComplete
			#await self.turn_pass
			
			#state = next_state
			changeLadyState(States.lady_main)
		
		States.lady_main:
			currentState = States.lady_main
			#next_state = States.lady_end
			#state = null
			board.lady_main()
			await SignalBus.ladyAnimationComplete
			#await self.turn_pass
			#state = next_state
			item_spawner.item_event_triggered()
			changeLadyState(States.lady_end)
			
		States.lady_end:
			currentState = States.lady_end
			#state = null
			board.lady_end()
			#next_state = States.player_draw
			await SignalBus.ladyAnimationComplete
			#await self.turn_pass
			#state = next_state
			board.check_winner()
			changePlayerState(States.player_draw)


func changeItemState(changeState):
	if currentState != States.player_main: return
	
	match changeState:
		
		States.severed_hand:
			for i in 5:
				board.draw_card()
			changePlayerState(States.player_end)
		
		States.dentures:
			board.run_dentures_code()
		
		States.brick:
			#state = null
			board.run_brick_code()
			bricked_wait = 3
			#await self.turn_pass
			await SignalBus.ladyAnimationComplete
			#state = States.player_draw
			changePlayerState(States.player_draw)


func changeStage():

	match stage:
	
		Stages.stage_1:
			win() #change later after states are out of process
			nextStage = Stages.stage_2
			item_spawner.threshold = 11 #this doesn't work, have something signal which stage it is on start
			
			SignalBus.emit_signal("readDialogueSignal", "winDialogue")
			await SignalBus.dialogueCompletedSignal
			state = States.player_draw # these are soon to be outdated, remember to change this

		Stages.stage_2:
			win() #change later after states are out of process
			nextStage = Stages.stage_2
			item_spawner.threshold = 8
			
			SignalBus.emit_signal("readDialogueSignal", "endDialogue")
			await SignalBus.dialogueCompletedSignal
			SignalBus.emit_signal("resetReadDialogue", "endDialogue")
			state = States.player_draw # these are soon to be outdated, remember to change this
	
	stage = nextStage
	get_tree().reload_current_scene() #this will cause all sorts of problems, change this later


func stringToEnumValueConverter(enumValueString : String):
	for enumValue in range(0, States.size()):
		if States.keys()[enumValue] == enumValueString:
			return (States.values()[enumValue])
			changePlayerState(States.values()[enumValue])
			break


func sendToChangePlayerState(stringToConvert : String):
	var convertedString = stringToEnumValueConverter(stringToConvert)
	changePlayerState(convertedString)


func sendToChangeLadyState(stringToConvert : String):
	var convertedString = stringToEnumValueConverter(stringToConvert)
	changeLadyState(convertedString)


func sendToChangeItemState(stringToConvert : String):
	var convertedString = stringToEnumValueConverter(stringToConvert)
	changeItemState(convertedString)


#probably replace both of these
func win():
	state = States.win

func lose():
	state = States.lose
	
func set_ray_pickable_on_card_placements( state ):
	for clickable_area in board.get_node("LadyCardOrganizer").get_children():
		clickable_area.get_node("Area3D").set_ray_pickable(state)
	for clickable_area in board.get_node("PlayerCardOrganizer").get_children():
		clickable_area.get_node("Area3D").set_ray_pickable(state)
	for clickable_area in board.get_node("PlayerCardOrganizer").get_children():
		clickable_area.get_node("Area3D").set_ray_pickable(state)
	#board.get_node("DECK").get_node("Area3D").set_ray_pickable(state)
