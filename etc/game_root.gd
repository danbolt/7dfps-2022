class_name GameRoot extends Control

onready var pause_root :PauseRoot = $pause_root

func pause_game():
	get_tree().paused = true
	pause_root.visible = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	pause_root.decorators_in()
	
func unpause_game():
	pause_root.decorators_out()
	
func on_decorators_done():
	get_tree().paused = false
	pause_root.visible = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
func handle_pause_press():
	if !(get_tree().paused):
		pause_game()
	elif (get_tree().paused):
		unpause_game()

func _ready():
	get_tree().paused = false
	pause_root.visible = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	var _pause_connect_result = pause_root.connect("done_exiting", self, "on_decorators_done")

func _process(_delta):
	if  Input.is_action_just_pressed("pause"):
		handle_pause_press()
