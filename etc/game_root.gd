class_name GameRoot extends Control

onready var pause_root :PauseRoot = $pause_root


onready var gameplay_viewport: Viewport = $ViewportContainer/Viewport

var current_stage: int = 0
var stages = [
	{
		'scene': "res://environments/gameplay_test.tscn"
	},
	{
		'scene': "res://environments/corridor_test.tscn"
	}
]

func on_player_completed_stage():
	pass
	
func teardown_stage():
	for child in gameplay_viewport.get_children():
		child.queue_free()

func start_stage(stageIndex: int):
	var nextSceneToInstance: String = stages[stageIndex % stages.size()].scene
	var nextSceneData: PackedScene = load(nextSceneToInstance)
	var nextScene = nextSceneData.instance()
	gameplay_viewport.add_child(nextScene)

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
	
	current_stage = 0
	start_stage(current_stage)
	teardown_stage()
	
	var _pause_connect_result = pause_root.connect("done_exiting", self, "on_decorators_done")

func _process(_delta):
	if  Input.is_action_just_pressed("pause"):
		handle_pause_press()
