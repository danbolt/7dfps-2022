extends Spatial

onready var player = $PlayerMovement

onready var subscreen: PlayerApps = $PlayerMovement/Camera/Subscreen

onready var camera_screen: Spatial = $PlayerMovement/Camera/Subscreen/CameraScreen

var enemy_dms_app = preload("res://hud_elements/app_screens/enemy_dms.tscn")

func on_ontro_done():
	print('done')

func on_first_phone_up(enemy_dms: EnemyDMs):
	player.disconnect("phone_up", self, "on_first_phone_up")
	
	subscreen.play_stuck_noise()
	
	yield(get_tree().create_timer(0.5, false), "timeout")
	
	var _connect_enemy_dms_done = enemy_dms.connect("done", self, "on_ontro_done")
	enemy_dms.play_evil_dracula_intro()
	

func buzz():
	yield(get_tree().create_timer(4.0, false), "timeout")
	
	subscreen.play_vibrate_sound()
	var enemy_dms: EnemyDMs = subscreen.instance_other_app(enemy_dms_app) as EnemyDMs
	
	player.connect("phone_up", self, "on_first_phone_up", [  enemy_dms ])

func _ready():
	subscreen.show_other_app_screen()
	buzz()

