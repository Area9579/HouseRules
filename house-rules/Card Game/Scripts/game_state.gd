extends Node

@onready var board
@onready var item_spawner

var introPlayed: bool = false

enum States {
	player_draw, player_main, player_end,
	lady_draw, lady_main, lady_end,
	win, lose, item_event, fall_event,
	dentures, bowling_ball, severed_hand
	}

enum Stages {
	stage_1, stage_2
}

var stage = Stages.stage_1
var nextStage = Stages.stage_2

@export var state = States.player_draw
@export var next_state = States.player_main
@export var ray_pickable_state = false

signal turn_pass

func _ready() -> void:
	connect("turn_pass", _turn_pass)
	
func _turn_pass(): 
	return true

var bricked_wait = 0
func _process(delta: float) -> void:
	if board == null or item_spawner == null:
		return
	match state:
		States.player_draw:
			
			bricked_wait -= 1
			if bricked_wait == 0:
				board.lady_reset()
			bricked_wait = max(0, bricked_wait)
			next_state = States.player_main
			
			if board.drawing == false:
				board.play_draw_sound(.5)
				board.draw_card()
				state = next_state
			
		States.player_main:
			next_state = States.player_end
			
			for card_placement in board.left_hand.hand_card_organizer.get_children():
				if card_placement.card == null and card_placement:
					state = next_state
					break
			
			ray_pickable_state = true
			set_ray_pickable_on_card_placements(ray_pickable_state)
			ray_pickable_state = false
			
		States.player_end: #TODO come back and make item event triggered only
			if bricked_wait == 0:
				DialogueManager.readDialouge("SpecialCards")
				
				next_state = States.lady_draw
				 #gurentee
				set_ray_pickable_on_card_placements(ray_pickable_state)
				state = next_state
				board.check_winner()
			else:
				next_state = States.player_draw
				state = next_state
		
		States.lady_draw:
			next_state = States.lady_main
			state = null
			
			board.lady_draw()
			await self.turn_pass
			
			state = next_state
		
		States.lady_main:
			next_state = States.lady_end
			state = null
			board.lady_main()
			await self.turn_pass
			state = next_state
			item_spawner.item_event_triggered()
			
		States.lady_end:
			state = null
			board.lady_end()
			next_state = States.player_draw
			await self.turn_pass
			state = next_state
			board.check_winner()
			
		
		States.win:
			next_state = null
		States.lose:
			next_state = null
		
		States.item_event:
			pass
		States.fall_event:
			pass
		
		States.severed_hand:
			for i in 5:
				board.draw_card()
			state = next_state
		
		States.dentures:
			board.run_dentures_code()
		
		States.bowling_ball:
			state = null
			board.run_brick_code()
			bricked_wait = 3
			await self.turn_pass
			state = States.player_draw
	
	match stage:
		Stages.stage_1:
			item_spawner.threshold = 5
		Stages.stage_2:
			item_spawner.threshold = 5



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
