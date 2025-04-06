extends BaseKeyIndicator

@export var cardPlacement: CardPlacement

var cardFalling: bool = false
var keybindList: Array[Array] = [["Q","A","Z"],["W","S","X"],["E","D","C"],["R","F","V"],["T","G","B","Space"]]


func _ready() -> void:
	#connect both of the signals for pressing and releasing keys
	Director.keyPressed.connect(pressedKey)
	#both of these are setting the text for the indicators, this will prob be changed later
	keyLabel.text = key
	timerLabel.text = str(mercyTimer)
	keyIsPressed = true


func _process(delta: float) -> void:
	if !keyIsPressed:
		if currentMercyTimer > 0:
			currentMercyTimer -= delta
		else:
			if cardPlacement.card != null and !cardFalling:
				cardFalling = true
				cardPlacement.card.launchCard()
				await get_tree().create_timer(3).timeout
				cardFalling = false
				cardPlacement.remove_card()
				keyIsPressed = true
				labelFullOpacity()
	
	updateTimerLabel()


func pressedKey(signalKey):
	#resets the timer, and turns the labels to be visible when key is pressed
	if signalKey == key:
		keyIsPressed = true
		keyLabel.modulate.a = 1
		timerLabel.modulate.a = 1


func switchKeys():
	currentMercyTimer = mercyTimer
	keyIsPressed = false
	for keybindRow in range(0,keybindList.size()):
		for keyIndex in range(0,keybindList[keybindRow].size()):
			if keybindList[keybindRow][keyIndex] == key:
				var randInt: int = randi_range(0,2)
				updateKey(keybindList[keybindRow][randInt])
				


func updateKey(newKey: String):
	key = newKey
	keyLabel.text = key
	labelHalfOpacity()
