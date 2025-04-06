extends BaseKeyIndicator

var quicktimeKeyList : Array[String] = ["Y","H","N","U","J","M","I","K","I","K","O","L","P"]
@onready var item_parent = get_parent().get_parent().get_parent()

func _ready() -> void:
	releasedKey = true
	randomizeKey()
	currentMercyTimer = mercyTimer
	#connect both of the signals for pressing and releasing keys
	Director.keyPressed.connect(keyIsPressed)
	Director.keyReleased.connect(keyIsReleased)
	#both of these are setting the text for the indicators, this will prob be changed later
	keyLabel.text = key
	timerLabel.text = str(mercyTimer)
	keyLabel.modulate.a = 0.5


func _process(delta: float) -> void:
	#decrease the timer until it hits 0
	if currentMercyTimer > 0:
		currentMercyTimer -= delta
	
	## if you hit the key in time:
	elif currentMercyTimer <= 0 and releasedKey == false: 
		labelHalfOpacity()
		if item_parent.name == "Item":
			item_parent.state = item_parent.States.in_hand
		self.queue_free()
	## if you dont hit the key in time:
	else: 
		labelHalfOpacity()
		if item_parent.name == "Item":
			item_parent.state = item_parent.States.falling
		self.queue_free()
	
	updateTimerLabel()


func keyIsPressed(signalKey):
	#resets the timer, and turns the labels to be visible when key is pressed
	if signalKey == key:
		releasedKey = false
		keyLabel.modulate.a = 1


func keyIsReleased(signalKey):
	#change bool to state that a key has been released
	if signalKey == key:
		keyLabel.modulate.a = 0.5


func randomizeKey(): #randomizes the keybind for the key you need to press
	var randInt : int = randi_range(0, quicktimeKeyList.size()-1)
	key = quicktimeKeyList[randInt]
