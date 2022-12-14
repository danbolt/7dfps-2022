class_name EntryElevator extends Spatial

onready var elevator = $Elevator

func _ready():
	yield(get_tree().create_timer(0.9, false), "timeout")
	
	elevator.open_doors()
