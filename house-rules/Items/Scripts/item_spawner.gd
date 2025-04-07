extends Node3D

@onready var timer: Timer = $Timer
@onready var new_item
@onready var right_hand = %HandRight

const ITEM = preload("res://Items/Scenes/Item.tscn")

var threshold : int = 5

func _ready() -> void:
	GameState.item_spawner = self
	timer.start(0.1)

func _process(delta: float) -> void:
	return

func item_event_triggered():
	print('spawned')
	var random_int = randi_range(1, 10)
	if right_hand.item != null:
		return
	elif random_int > threshold:
		spawn_item()

func spawn_item():
	
	if new_item != null:
		return
	new_item = ITEM.instantiate()
	add_child(new_item)
	$AudioStreamPlayer.play()
	#new_item.position = self.position
	match randi_range(1,2):
		1: new_item.type = "brick" 
		2: new_item.type = "dentures"
	new_item.verify()
	
	new_item.hand = right_hand
	move_item_to_hand(new_item)

func move_item_to_hand( item: Item ):
	if item == null:
		return
	#if right_hand.item != null:
		#right_hand.item.remove()
	item.reparent(right_hand, true)
	right_hand.item = item
	#new_item = null
	return right_hand


func _on_timer_timeout() -> void:
	if new_item != null:
		new_item.queue_free()
	timer.stop()
