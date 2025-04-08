class_name Board extends Node3D

const CARD = preload("res://Card Game/Scenes/card.tscn")

@onready var lady_card_organizer: Node3D = $LadyCardOrganizer
@onready var player_card_organizer: Node3D = $PlayerCardOrganizer
@onready var card_generator: CardGenerator
@onready var deck = $DECK
@onready var left_hand = $"../PlayerBody/HandLeft"
@onready var right_hand = $"../PlayerBody/HandRight"
@onready var drawing = false

@export var selected_card = null
@export var selected_placement = null
@onready var deck_mesh: Node3D = $deck

var player_score = [0,0,0]
var player_final = 0

var lady_score = [0,0,0]
var lady_final = 0


func _ready() -> void:
	GameState.board = self

	card_generator = CardGenerator.new()
	
	for card_placement in lady_card_organizer.get_children():
		card_placement.connect("placement_clicked", lady_card_clicked)
	
	for card_placement in player_card_organizer.get_children():
		card_placement.connect("placement_clicked", player_card_clicked)
	
	## signals for player hand are initialized on the node Hand in main so that
	## the signals only connect once children nodes are ready (ik theres other
	## ways around this but oops, this still works)
	
	right_hand.connect("item_clicked", item_clicked)
	quad_lady_draw()


func _process(delta: float) -> void:
	highlight_matched_cards()
	proces_lady_hand(delta)
	if not left_hand.hand_is_initialized:
		for i in 5:
			draw_card()
		left_hand.hand_is_initialized = true
	#if Input.is_action_just_released("reset"):
		#clear_board()

func item_clicked( item : Item ):
	if GameState.state != GameState.States.player_main: return
	match item.type:
		"dentures": 
			GameState.state = GameState.States.dentures
			dent_item = item
		"brick": 
			GameState.state = GameState.States.bowling_ball
			brick_item = item
	

func highlight_matched_cards():
	var hovered_card = null
	
	var arr : Array = []
	

	for child in player_card_organizer.get_children():
		arr.append(child)
	
	# remove highlights from cards
	for card_placement in arr:
		card_placement.setSelection(false)
	
	if selected_placement == null or selected_placement.card == null:
		return
	
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
			if card_placement.name.left(1) == col and card_placement.card != null:
				if selected_placement.card.value_name == card_placement.card.value_name:
					card_placement.setSelection(true)
		else:
			card_placement.setSelection(false)

var brick_item = null
func run_brick_code():
	
	$"../PlayerBody/PlayerAnimator".play("brick_throw")
	
func hit_lady():
	var tween = get_tree().create_tween()
	brick_item.top_level = true
	tween.tween_property(brick_item, "global_position", Vector3(-3.516, 2.771, -2.647), .1)
	await tween.finished
	lady_react()
	brick_item.remove()
	brick_item = null

func lady_react():
	$"../BEUASTYYYYY/beautyAnimator".play("react")
	await $"../BEUASTYYYYY/beautyAnimator".animation_finished
	GameState.emit_signal("turn_pass")
func lady_reset():
	$"../BEUASTYYYYY/beautyAnimator".play("backup")

var dent_item = null
var column_to_eat = null
func run_dentures_code():
	var hovered_card = null
	
	
#region selecting hovering
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
#endregion
	GameState.state = null
	#START HERE AWAIT
#region nuking

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
#endregion

## moving around cards logic
func place_card( card_placement : CardPlacement, card = null ):
	pos = card_placement
	var new_card = null
	if card == null:
		new_card = card_generator.get_new_card()
	else: new_card = card
	
	if new_card == null:
		return
	card_placement.set_card( new_card )
	
	return card_placement

func clear_board():
	card_generator.get_new_deck()
	
	var arr : Array = []
	
	for child in lady_card_organizer.get_children():
		arr.append(child)
	for child in player_card_organizer.get_children():
		arr.append(child)
	for child in left_hand.hand_card_organizer.get_children():
		arr.append(child)
	
	for card_placement in arr:
		if card_placement.card != null:
			card_placement.remove_card()

func switch_cards( desired_placement ):
	if desired_placement.card != null or selected_placement.card == null: 
		return
	selected_placement.card.reparent( desired_placement, true)
	desired_placement.set_card( selected_placement.card )
	selected_placement.card = null
	selected_placement.update_text()
	selected_placement.setSelection(false)
	selected_placement = null
	GameState.state = GameState.next_state
	return desired_placement

	
## signals connect from lady's cards, player's cards, player's hands, and deck, respectively
func lady_card_clicked( card_placement : CardPlacement ):
	if selected_placement == null:
		return
		# add code here to nuke all cards of same suit
	#switch_cards( card_placement )

func player_card_clicked( card_placement : CardPlacement ):
	if GameState.state != GameState.States.player_main: return
	if selected_placement == null:
		return
		# add code here to nuke all cards of same suit
	switch_cards( card_placement )
	$PlayerPlace.stop()
	$PlayerPlace.play()

func player_hand_clicked( card_placement : CardPlacement ):
	selected_card = card_placement.card
	if selected_placement != null:
		selected_placement.setSelection(false)
	selected_placement = card_placement
	if selected_placement.card != null:
		selected_placement.setSelection(true)

func play_draw_sound(at_point):
	$PlayerDraw.play(at_point)

func draw_card():
	drawing = true
	for card_placement in left_hand.hand_card_organizer.get_children():
		if card_placement.card == null:
			var new_card = card_generator.get_new_card()
			if new_card == null:
				return
			card_placement.set_card(new_card)
			new_card.global_position = deck.global_position
			
			new_card.rotation = deck.rotation
			#card_placement.set_card_position()
			
	drawing = false

func nuke_cards( card ):
	var value
	if card.value_name == "joker":
		value = card.color
	elif card.value_name == "king":
		value = card.suit
	else:
		value = card.value_name
	
	var arr : Array = []
	
	for child in lady_card_organizer.get_children():
		arr.append(child)
	for child in player_card_organizer.get_children():
		arr.append(child)
	
	for card_placement in arr:
		if card_placement.card != null:
			if card_placement.card.value_name == value:
				card_placement.remove_card()
			elif card_placement.card.suit == value:
				card_placement.remove_card()
			elif card_placement.card.color == value:
				card_placement.remove_card()

#region Jude Stuff

#JUDE SHIT
#JUDE SHIT
#JUDE SHIT
#JUDE SHIT
#JUDE SHIT
#JUDE SHIT
@onready var animation_manager: AnimationManger = $"../AnimationManager"
@onready var target_right_arm: Marker3D = $"../BEUASTYYYYY/TargetRightArm"
@onready var lady_hand_organizer: Node3D = $"../BEUASTYYYYY/Armature/Skeleton3D/BoneAttachment3D/LadyHandOrganizer"
@onready var hand_draw: Node3D = $"../BEUASTYYYYY/Armature/Skeleton3D/righthand/Node3D"


func lady_draw():
	animation_manager.play_draw_grap()

var gen_card : Card = null
func draw_lady():
	gen_card = card_generator.get_new_card()
	hand_draw.add_child(gen_card)
	gen_card.global_position = deck.global_position
	gen_card.rotation = deck.rotation
	
	gen_card.scale = Vector3.ONE * 5

func proces_lady_hand(delta):
	if gen_card:
		if gen_card.placement_parent != null:
			return
		gen_card.global_position =  hand_draw.global_position
		gen_card.global_rotation = $"../BEUASTYYYYY/Armature/Skeleton3D/righthand".global_rotation
		

func put_in_hand():
	for i : CardPlacement in $"../BEUASTYYYYY/Armature/Skeleton3D/BoneAttachment3D/LadyHandOrganizer".get_children():
		if i.card == null:
			gen_card.rigidBody.scale = Vector3(.2,.2,.2)
			i.set_card(gen_card)
			return

var wait = 0
var pos = null
var random_choice = true
#make current card.

var new_card : Card = null
var start_hand = null
var where_to_go = null
func lady_main():
	wait += 1
	#chose right here
	new_card= null
	start_hand = null
	where_to_go = null
	sort_through_hand()
			#new_card.get_parent().remove_child(new_card)
			#hand_draw.add_child(new_card)
	
	new_card.placement_parent = null
	start_hand.remove_lady_child()
	
	pos = where_to_go.global_position
	animation_manager.play_card(pos, new_card, where_to_go)

var matched = false
func sort_through_hand():
	for i in $"../BEUASTYYYYY/Armature/Skeleton3D/BoneAttachment3D/LadyHandOrganizer".get_children():
		
		if i.card != null:
			new_card = i.card
			start_hand = i
			where_to_go = lady_match(new_card)
			if matched: 
				matched = false
				return #MATCHED!!! otherwise return
			
	
func lady_end():
	animation_manager.lady_end()

func get_empty_list():
	var empty_list = []
	for i in lady_card_organizer.get_children():
		if i.card == null:
			empty_list += [i]
	return empty_list

func set_card(placement, card):
	placement.set_card(card)
	card.global_position += Vector3(0,.1,0)
	gen_card = null

func lady_random(new_card):
	random_choice = true
	var empty_list = get_empty_list()
	if !empty_list.is_empty():
		var random_choice = empty_list[randi() % empty_list.size()]
		return random_choice

func quad_lady_draw():
	for i in 4:
		var card_placement = $"../BEUASTYYYYY/Armature/Skeleton3D/BoneAttachment3D/LadyHandOrganizer".get_child(i)
		if card_placement.card == null:
			
			var new_card = card_generator.get_new_card()
			if new_card == null:
				return
			card_placement.set_card(new_card)
			new_card.scale = Vector3.ONE * 5
			
			#new_card.rotation = deck.rotation
			#card_placement.set_card_position()


func lady_match(new_card):
	var chosen_card = null #get the row
	for i in lady_card_organizer.get_children():
		if i.card != null:
			if i.card.value_name == new_card.value_name:
				if int(String(i.name)[0]) == 0:
					if $"LadyCardOrganizer/00".card == null: 
						matched = true
						return $"LadyCardOrganizer/00"
					elif $"LadyCardOrganizer/01".card == null: 
						matched = true
						return $"LadyCardOrganizer/01"
					elif $"LadyCardOrganizer/02".card == null: 
						matched = true
						return $"LadyCardOrganizer/02"
				elif int(String(i.name)[0]) == 1:
					if $"LadyCardOrganizer/10".card == null: 
						matched = true
						return $"LadyCardOrganizer/10"
					elif $"LadyCardOrganizer/11".card == null: 
						matched = true
						return $"LadyCardOrganizer/11"
					elif $"LadyCardOrganizer/12".card == null: 
						matched = true
						return $"LadyCardOrganizer/12"
				elif int(String(i.name)[0]) == 2:
					if $"LadyCardOrganizer/20".card == null: 
						matched = true
						return $"LadyCardOrganizer/20"
					elif $"LadyCardOrganizer/21".card == null: 
						matched = true
						return $"LadyCardOrganizer/21"
					elif $"LadyCardOrganizer/22".card == null: 
						matched = true
						return  $"LadyCardOrganizer/22"
					
				else: return lady_random(new_card)
	return lady_random(new_card)
	
func lady_destroy(new_card):
	
	var chosen_card = null #get the row
	for i in player_card_organizer.get_children():
		if i.card != null:
			if i.card.value_name == new_card.value_name:
				if int(String(i.name)[0]) == 0:
					if $"LadyCardOrganizer/00".card == null: return $"LadyCardOrganizer/00"
					elif $"LadyCardOrganizer/01".card == null: return $"LadyCardOrganizer/01"
					elif $"LadyCardOrganizer/02".card == null: return $"LadyCardOrganizer/02"
				elif int(String(i.name)[0]) == 1:
					if $"LadyCardOrganizer/10".card == null: return $"LadyCardOrganizer/10"
					elif $"LadyCardOrganizer/11".card == null: return $"LadyCardOrganizer/11"
					elif $"LadyCardOrganizer/12".card == null: return $"LadyCardOrganizer/12"
				elif int(String(i.name)[0]) == 2:
					if $"LadyCardOrganizer/20".card == null: return $"LadyCardOrganizer/20"
					elif $"LadyCardOrganizer/21".card == null: return  $"LadyCardOrganizer/21"
					elif $"LadyCardOrganizer/22".card == null: return  $"LadyCardOrganizer/22"
				else: return lady_random(new_card)
	return lady_random(new_card)


func update_row(amount : int, col : int, person : int):
	if person == 0: #player
		$PlayerColumnText.get_child(col).text = str(amount)
		player_score[col] = amount
		player_final = 0
		for i in player_score:
			player_final += i
		$PlayerColumnText/FinalScore.text = str(player_final)
	if person == 1:
		$LadyColumnText.get_child(col).text = str(amount)
		lady_score[col] = amount
		lady_final = 0
		for i in lady_score:
			lady_final += i
		$LadyColumnText/FinalScore.text = str(lady_final)

func check_winner():
	var lady_full = true
	var player_full = true
	for i in lady_card_organizer.get_children():
		if i.card == null: lady_full = false
	for i in player_card_organizer.get_children():
		if i.card == null: player_full = false
	if !lady_full and !player_full: return
	if player_final > lady_final: 
		GameState.win()
		if GameState.stage == GameState.Stages.stage_1:
			GameState.stage = GameState.nextStage
			DialogueManager.readDialouge("Win")
			await DialogueManager.dialogueComplete
			get_tree().reload_current_scene()
		elif GameState.stage == GameState.Stages.stage_2:
			DialogueManager.readDialouge("End")
			await DialogueManager.dialogueComplete
			get_tree().reload_current_scene()
	else: 
		GameState.lose()
		DialogueManager.readDialouge("Lose")
		await DialogueManager.dialogueComplete
		get_tree().reload_current_scene()
		
	
#endregion
