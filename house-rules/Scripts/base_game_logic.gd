extends Node3D

@onready var x: Label3D = $Rows/X
@onready var y: Label3D = $Rows/Y
@onready var z: Label3D = $Rows/Z

func _ready() -> void:
	var matrix = [["00","01","02"],["10","11","12"],["20","21","22"]]
	
	print(matrix[0][2])
	
	
	
	
