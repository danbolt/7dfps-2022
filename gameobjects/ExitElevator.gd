extends Spatial

onready var elevator = $Elevator
onready var detection_zone = $DetectionZone


func player_approached(_entry):
	elevator.open_doors()
	
	detection_zone.disconnect("body_entered", self, "player_approached")

func _ready():
	var connect_to_zone_result = detection_zone.connect("body_entered", self, "player_approached")
	assert(connect_to_zone_result == OK)

