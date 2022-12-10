extends Node

export var y_invert: bool = false

export var x_sensitivity: float = 0.0
export var y_sensitivity: float = 0.0

func _ready():
	pass # Replace with function body.

func get_y_invert():
	return y_invert
	
func set_y_invert(val: bool):
	y_invert = val

func get_x_sensitivity():
	return x_sensitivity
	
func set_x_sensitivity(val: float):
	x_sensitivity = val
	
func get_y_sensitivity():
	return y_sensitivity
	
func set_y_sensitivity(val: float):
	y_sensitivity = val
