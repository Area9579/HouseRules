extends Node

@onready var board : Board

enum States {
	player_draw, player_main, player_end,
	lady_draw, lady_main, lady_end,
	win, lose, item_event, fall_event
	}

@export var state = States.player_draw
@export var next_state = States.player_main
@export var ray_pickable_state = false

signal turn_pass

func _ready() -> void:
	connect("turn_pass", _turn_pass)
	
func _turn_pass(): return true

func _process(delta: float) -> void:
	if board == null:
		return
	match state:
		States.player_draw:
			next_state = States.player_main
			if board.drawing == false:
				board.deck_clicked(0)
			
		States.player_main:
			next_state = States.player_end
			ray_pickable_state = true
			set_ray_pickable_on_card_placements(ray_pickable_state)
			ray_pickable_state = false
			
		States.player_end:
			# trigger item shit here
			next_state = States.lady_draw
			set_ray_pickable_on_card_placements(ray_pickable_state)
			state = next_state
			board.check_winner()
		
		States.lady_draw:
			next_state = States.lady_main
			
			state = next_state
		States.lady_main:
			next_state = States.lady_end
			state = null
			board.lady_main()
			await _turn_pass()
			state = next_state
		States.lady_end:
			next_state = States.player_draw
			state = next_state
			board.check_winner()
		
		States.win:
			next_state = null
			print("YAYYYYYYYYYYYYYYYYYYYYYYYYYYYYYY")
		States.lose:
			next_state = null
			print("NOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO")
		
		States.item_event:
			pass
		States.fall_event:
			pass



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
