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
	#if Input.is_action_just_pressed("reset"):
		#switchKeys()
	if !keyIsPressed:
		if currentMercyTimer > 0:
			currentMercyTimer -= delta
		else:
			if cardPlacement.card != null and !cardFalling:
				cardFalling = true
				cardPlacement.card.launchCard()
				owner.get_node("Board").nuke_cards(cardPlacement.card)
				await get_tree().create_timer(3).timeout
				cardFalling = false
				keyIsPressed = true
				labelFullOpacity()
	
	updateTimerLabel()


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
