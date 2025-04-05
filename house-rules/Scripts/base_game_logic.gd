extends Node3D

@onready var x: Label3D = $Rows/X
@onready var y: Label3D = $Rows/Y
@onready var z: Label3D = $Rows/Z

var matrix = [["00","01","02"],["10","11","12"],["20","21","22"]]

func _ready() -> void:
	
	update_board_scores()

func update_board_scores():
	var row_x = 0
	var row_y = 0
	var row_z = 0
	
	#group up multipliers
	for i in 3:
		print(matrix[i])
		for u in matrix[i]:
			pass
	
	#multiply
