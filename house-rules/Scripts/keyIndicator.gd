extends BaseKeyIndicator

@export var cardPlacement: CardPlacement

var cardFalling: bool = false
var keybindList: Array[Array] = [["Q","A","Z"],["W","S","X"],["E","D","C"],["R","F","V"]]


func _ready() -> void:
	#connect both of the signals for pressing and releasing keys
	Director.keyPressed.connect(keyIsPressed)
	Director.keyReleased.connect(keyIsReleased)
	#both of these are setting the text for the indicators, this will prob be changed later
	keyLabel.text = key
	timerLabel.text = str(mercyTimer)


func _process(delta: float) -> void:
	#if Input.is_action_just_pressed("left"):
		#switchKeys()
	#if a key is released, then decrease the timer
	if releasedKey:
		if currentMercyTimer > 0:
			currentMercyTimer -= delta
		else:
			labelHalfOpacity()
			if cardPlacement.card != null and !cardFalling:
				cardFalling = true
				cardPlacement.card.launchCard()
				await get_tree().create_timer(3).timeout
				cardFalling = false
				cardPlacement.remove_card()
	
	updateTimerLabel()


func keyIsPressed(signalKey):
	#resets the timer, and turns the labels to be visible when key is pressed
	if signalKey == key:
		currentMercyTimer = mercyTimer
		releasedKey = false
		keyLabel.modulate.a = 1
		timerLabel.modulate.a = 1


func keyIsReleased(signalKey):
	#change bool to state that a key has been released
	if signalKey == key:
		releasedKey = true


func switchKeys():
	for keybindRow in range(0,keybindList.size()):
		for keyIndex in range(0,keybindList[keybindRow].size()):
			if keybindList[keybindRow][keyIndex] == key:
				var randInt: int = randi_range(0,2)
				#print(keybindList[keybindRow][randInt])
				updateKey(keybindList[keybindRow][randInt])
				

func updateKey(newKey: String):
	key = newKey
	keyLabel.text = key
	releasedKey = true
	labelHalfOpacity()
	currentMercyTimer = 8
