class_name Elevator extends Spatial


onready var left_door = $LeftDoor
onready var right_door = $RightDoor

onready var left_door_initial_translation = $LeftDoor.translation
onready var right_door_initial_translation = $RightDoor.translation

onready var left_door_sound = $LeftDoor/door_sound
onready var right_door_sound = $RightDoor/door_sound

onready var ding_play = $ding_play

func play_bell():
	if not ding_play.playing:
		ding_play.play()

func open_doors():
	var tLeft = get_tree().create_tween()
	tLeft.tween_property(left_door, "translation", left_door_initial_translation + (Vector3.RIGHT * -2.1), 1.01)
	
	var tRight = get_tree().create_tween()
	tRight.tween_property(right_door, "translation", right_door_initial_translation + (Vector3.RIGHT * 2.1), 1.0)
	
	left_door_sound.play()
	right_door_sound.play()
	
	tRight.connect("finished", self, "play_bell")
	
func close_doors():
	var tLeft = get_tree().create_tween()
	tLeft.tween_property(left_door, "translation", left_door_initial_translation, 1.01)
	
	var tRight = get_tree().create_tween()
	tRight.tween_property(right_door, "translation", right_door_initial_translation, 1.0)
	
	left_door_sound.play()
	right_door_sound.play()

