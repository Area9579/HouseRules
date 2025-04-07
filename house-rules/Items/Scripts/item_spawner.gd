extends Node3D

@onready var timer: Timer = $Timer
@onready var new_item
@onready var right_hand = %HandRight

const ITEM = preload("res://Items/Scenes/Item.tscn")

var threshold : int

func _ready() -> void:
	GameState.item_spawner = self
	timer.start(0.1)

func _process(delta: float) -> void:
	return

func item_event_triggered():
	var random_int = randi_range(1, 10)
	if random_int > threshold:
		spawn_item()
	else:
		pass
		# dont spawn item

func spawn_item():
	if new_item != null:
		return
	new_item = ITEM.instantiate()
	#new_item.position = self.position
	add_child(new_item)
	timer.start(10)

func move_item_to_hand( item: Item ):
	if item == null:
		return
	if right_hand.item != null:
		right_hand.item.remove()
	item.reparent(right_hand, true)
	right_hand.item = item
	new_item = null
	return right_hand


func _on_timer_timeout() -> void:
	if new_item != null:
		new_item.queue_free()
	timer.stop()
