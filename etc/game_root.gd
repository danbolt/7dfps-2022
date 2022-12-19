class_name GameRoot extends Control

onready var pause_root :PauseRoot = $pause_root
onready var curtains: Curtains = $curtains

onready var gameplay_viewport: Viewport = $ViewportContainer/Viewport

onready var title_text: Label = $"Title Cover/Label"
onready var subtitle_text: Label = $"Title Cover/Subtitle"

onready var start_game_button: Button = $title_screen/start_game_button

onready var title_screen: Control = $title_screen

var current_stage: int = 0
var stages = [
	{
		'scene': "res://environments/stage0.tscn"
	},
	{
		'scene': "res://environments/stage1.tscn"
	},
	{
		'scene': "res://environments/stage2.tscn"
	},
	{
		'scene': "res://environments/stage3.tscn"
	},
	{
		'scene': "res://environments/boss_room.tscn"
	}
]

func player_finished_stage():
	on_player_completed_stage()
	
func player_died():
	on_player_died()
	
func on_player_died():
	curtains.close_curtains()
	
	yield(curtains, "finished_closing")
	
	hide_title_text()
	
	yield(get_tree().create_timer(0.7), "timeout")

	teardown_stage()
	start_stage(current_stage)
	
	curtains.open_curtains()
#
	yield(curtains, "finished_opening")

func on_player_completed_stage():
	
	if (current_stage > 0):
		show_title_text("floor clear")
	
	curtains.close_curtains()
	
	yield(curtains, "finished_closing")
	
	yield(get_tree().create_timer(0.7), "timeout")
#
	current_stage = current_stage + 1
	teardown_stage()
	
	hide_title_text()
	
	start_stage(current_stage)
	
	curtains.open_curtains()
#
	yield(curtains, "finished_opening")

	
	
	
func teardown_stage():
	for child in gameplay_viewport.get_children():
		child.queue_free()
		# Manually remove the child from the tree so `WorldEnvironment`s don't conflict with one another
		gameplay_viewport.remove_child(child)

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
	if (curtains.is_moving):
		return
		
	if title_screen.visible:
		return
	
	if !(get_tree().paused):
		pause_game()
	elif (get_tree().paused):
		unpause_game()

func show_title_text(text: String):
	title_text.visible = true
	title_text.text = text
	
func hide_title_text():
	title_text.visible = false

func show_subtitle_text(text: String):
	subtitle_text.visible = true
	subtitle_text.text = text
	
func hide_subttitle_text():
	subtitle_text.visible = false
	
func on_start_game_pressed():
	title_screen.visible = false
	
	yield(get_tree().create_timer(0.5), "timeout")
	
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	start_stage(current_stage)
	
	yield(get_tree().create_timer(0.25), "timeout")
	
	curtains.open_curtains()

func _ready():
	get_tree().paused = false
	pause_root.visible = false
	
	title_text.visible = false
	subtitle_text.visible = false
	
	var _connect_to_start_game = start_game_button.connect("button_down", self, "on_start_game_pressed")
	
	var _pause_connect_result = pause_root.connect("done_exiting", self, "on_decorators_done")

func _process(_delta):
	if  Input.is_action_just_pressed("pause"):
		handle_pause_press()
		
	if (Input.is_action_just_pressed("take_screenshot")):
		var image = get_viewport().get_texture().get_data()
		image.flip_y()
		image.save_png("screenshot" + Time.get_datetime_string_from_system() +  ".png")
