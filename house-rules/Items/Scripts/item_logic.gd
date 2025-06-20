extends Node

var dent_item = null
var brick_item = null
var column_to_eat = null

@onready var right_hand = %HandRight

func _ready() -> void:
	right_hand.connect("item_clicked", item_clicked)

func item_clicked( item : Item ):
	if GameState.state != GameState.States.player_main: return
	match item.type:
		"dentures": 
			GameState.state = GameState.States.dentures
			dent_item = item
		"brick": 
			GameState.state = GameState.States.bowling_ball
			brick_item = item

func run_dentures_code():
	var hovered_card = null
	var arr : Array = []
	
	for child in lady_card_organizer.get_children():
		arr.append(child)
	for child in player_card_organizer.get_children():
		arr.append(child)
	
	for card_placement in arr:
		if card_placement.has_mouse:
			hovered_card = card_placement.name
			break

	# get column of hovered card
	var col
	if hovered_card != null:
		col = hovered_card.left(1)
	else:
		col = ""
		

	# highlight all other cards in column
	for card_placement in arr:
		if hovered_card != null:
			if card_placement.name.left(1) == col:
				card_placement.setSelection(true)
				column_to_eat = card_placement
		else:
			card_placement.setSelection(false)
	
	if !Input.is_action_just_released("left"):
		return
	GameState.state = null
	#START HERE AWAIT


	var tween_col = get_tree().create_tween()
	if column_to_eat != null:
		tween_col.tween_property(%HandRight, "global_position:z", column_to_eat.global_position.z - .05, .8).set_ease(Tween.EASE_OUT)
	else: tween_col.tween_property(%HandRight, "global_position:z",%HandRight.global_position.z + .01, .8).set_ease(Tween.EASE_OUT)
	
	
	await tween_col.finished #x -4
	var tween_go = get_tree().create_tween()
	dent_item.top_level = true
	dent_item.state = dent_item.States.empty
	
	tween_go.tween_property(dent_item, "global_position:x", -4.0, 1.7).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_EXPO)
	dent_item.start_dent()
	await tween_go.finished
	# nuke highlighted cards
	
	
	for card_placement in arr:
		if hovered_card != null:
			if card_placement.name.left(1) == col:
				card_placement.remove_card()
	
	# remove highlights from cards
	for card_placement in arr:
		card_placement.setSelection(false)
	
	
	#await $"../PlayerBody/PlayerAnimator".animation_finished
	
	dent_item.remove()
	dent_item = null
	column_to_eat = null
	GameState.state = GameState.next_state


func run_brick_code():
	$"../PlayerBody/PlayerAnimator".play("brick_throw")

func hit_lady():
	var tween = get_tree().create_tween()
	brick_item.top_level = true
	tween.tween_property(brick_item, "global_position", Vector3(-3.516, 2.771, -2.647), .1)
	await tween.finished
	self.owner.get_node("BEAUSTYYYYY").lady_react()
	brick_item.remove()
	brick_item = null
