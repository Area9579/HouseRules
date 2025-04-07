extends BaseKeyIndicator

var quicktimeKeyList : Array[String] = ["Y","H","N","U","J","M","I","K","I","K","O","L","P"]
@onready var item_parent = get_parent().get_parent().get_parent()

func _ready() -> void:
	#connect both of the signals for pressing and releasing keys
	Director.keyPressed.connect(pressedKey)
	keyIsPressed = false
	randomizeKey()
	currentMercyTimer = mercyTimer
	#both of these are setting the text for the indicators, this will prob be changed later
	keyLabel.text = key
	timerLabel.text = str(mercyTimer)
	keyLabel.modulate.a = 0.5


func _process(delta: float) -> void:
	#decrease the timer until it hits 0
	if currentMercyTimer > 0:
		currentMercyTimer -= delta
	
	## if you hit the key in time:
	elif currentMercyTimer <= 0 and keyIsPressed == true: 
		if item_parent.name == "Item":
			item_parent.state = item_parent.States.in_hand
		self.queue_free()
	## if you dont hit the key in time:
	else: 
		if item_parent.name == "Item":
			item_parent.state = item_parent.States.falling
		self.queue_free()
	
	updateTimerLabel()


func randomizeKey(): #randomizes the keybind for the key you need to press
	var randInt : int = randi_range(0, quicktimeKeyList.size()-1)
	key = quicktimeKeyList[randInt]
