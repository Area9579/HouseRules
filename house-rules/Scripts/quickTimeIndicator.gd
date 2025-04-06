extends BaseKeyIndicator

var quicktimeKeyList : Array[String] = ["Y","H","N","U","J","M","I","K","I","K","O","L","P"]


func _ready() -> void:
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
	elif currentMercyTimer <= 0 and releasedKey == false: #if you hit the key in time
		labelHalfOpacity()
		self.queue_free()
	else: #what happens when you miss the QTE
		labelHalfOpacity()
		get_tree().quit() #replace this with death later
	
	updateTimerLabel()


func keyIsPressed(signalKey):
	#resets the timer, and turns the labels to be visible when key is pressed
	if signalKey == key:
		releasedKey = false
		keyLabel.modulate.a = 1


func keyIsReleased(signalKey):
	#change bool to state that a key has been released
	if signalKey == key:
		releasedKey = true
		keyLabel.modulate.a = 0.5


func randomizeKey(): #randomizes the keybind for the key you need to press
	var randInt : int = randi_range(0, quicktimeKeyList.size()-1)
	key = quicktimeKeyList[randInt]
