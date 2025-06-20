extends Node3D

const REGULAR = preload("res://raw_assets/regular.tres")
const TALK = preload("res://raw_assets/talk.tres")
const BLINK = preload("res://raw_assets/blink.tres")

@onready var blinktimer: Timer = $blinktimer
@onready var look_at: Marker3D = $Armature/Skeleton3D/LookAt
@onready var head_mesh: MeshInstance3D = $Armature/Skeleton3D/Icosphere_002
@onready var animation_manager: AnimationManger = $"../AnimationManager"
@onready var target_right_arm: Marker3D = $TargetRightArm
@onready var lady_hand_organizer: Node3D = $Armature/Skeleton3D/BoneAttachment3D/LadyHandOrganizer
@onready var hand_draw: Node3D = $Armature/Skeleton3D/righthand/Node3D
@onready var board: Board = $"../Board"


var gen_card : Card = null
var wait = 0
var pos = null
var random_choice = true
var new_card : Card = null
var start_hand = null
var where_to_go = null
var matched = false

var talking = false
var sin_talk = 0

func _ready() -> void:
	quad_lady_draw()
	GameState.lady = self

func _process(delta: float) -> void:
	process_lady_hand(delta)
	if talking:
		sin_talk += delta * 30
		if sin(sin_talk) > 0: head_mesh.set_surface_override_material(0, REGULAR)
		else: head_mesh.set_surface_override_material(0, TALK)

func set_stop_talk():
	head_mesh.set_surface_override_material(0, REGULAR)
	talking = false

func lady_react():
	$"../BEUASTYYYYY/beautyAnimator".play("react")
	await $"../BEUASTYYYYY/beautyAnimator".animation_finished
	GameState.emit_signal("turn_pass")

func lady_reset():
	$"../BEUASTYYYYY/beautyAnimator".play("backup")

func lady_draw():
	animation_manager.play_draw_grap()
	draw_lady()

func draw_lady():
	gen_card = board.get_new_card()
	hand_draw.add_child(gen_card)
	gen_card.scale = Vector3.ONE * 5

func process_lady_hand(delta):
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

func sort_through_hand():
	for i in lady_hand_organizer.get_children():
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
	for i in board.get_lady_card_placements():
		if i.card == null:
			empty_list += [i]
	return empty_list

func lady_random(new_card):
	random_choice = true
	var empty_list = get_empty_list()
	if !empty_list.is_empty():
		var random_choice = empty_list[randi() % empty_list.size()]
		return random_choice

func quad_lady_draw():
	for i in 4:
		var card_placement = $"Armature/Skeleton3D/BoneAttachment3D/LadyHandOrganizer".get_child(i)
		if card_placement.card == null:
			
			var new_card = board.get_new_card()
			if new_card == null:
				return
			card_placement.set_card(new_card)
			new_card.scale = Vector3.ONE * 5
			
			#new_card.rotation = deck.rotation
			#card_placement.set_card_position()

func lady_match(new_card):
	var chosen_card = null #get the row
	for i in board.get_lady_card_placements():
		if i.card != null:
			if i.card.value_name == new_card.value_name:
				if int(String(i.name)[0]) == 0:
					if $"../Board/LadyCardOrganizer/00".card == null: 
						matched = true
						return $"../Board/LadyCardOrganizer/00"
					elif $"../Board/LadyCardOrganizer/01".card == null: 
						matched = true
						return $"../Board/LadyCardOrganizer/01"
					elif $"../Board/LadyCardOrganizer/02".card == null: 
						matched = true
						return $"../Board/LadyCardOrganizer/02"
				elif int(String(i.name)[0]) == 1:
					if $"../Board/LadyCardOrganizer/10".card == null: 
						matched = true
						return $"../Board/LadyCardOrganizer/10"
					elif $"../Board/LadyCardOrganizer/11".card == null: 
						matched = true
						return $"../Board/LadyCardOrganizer/11"
					elif $"../Board/LadyCardOrganizer/12".card == null: 
						matched = true
						return $"../Board/LadyCardOrganizer/12"
				elif int(String(i.name)[0]) == 2:
					if $"../Board/LadyCardOrganizer/20".card == null: 
						matched = true
						return $"../Board/LadyCardOrganizer/20"
					elif $"../Board/LadyCardOrganizer/21".card == null: 
						matched = true
						return $"../Board/LadyCardOrganizer/21"
					elif $"../Board/LadyCardOrganizer/22".card == null: 
						matched = true
						return  $"../Board/LadyCardOrganizer/22"
					
				else: return lady_random(new_card)
	return lady_random(new_card)

func lady_destroy(new_card):
	var chosen_card = null #get the row
	for i in board.get_player_card_placements():
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

func _on_blinktimer_timeout() -> void:
	blinktimer.start(randf_range(1.0,10.0))
	
	head_mesh.set_surface_override_material(0, BLINK)
	await get_tree().create_timer(.1).timeout
	head_mesh.set_surface_override_material(0, REGULAR)
