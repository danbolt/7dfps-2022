extends Spatial

onready var player = $PlayerMovement

onready var subscreen: PlayerApps = $PlayerMovement/Camera/Subscreen

onready var camera_screen: Spatial = $PlayerMovement/Camera/Subscreen/CameraScreen

onready var left_pano = $opening_pano/left_pano
onready var right_pano = $opening_pano/right_pano
onready var temp_loor = $tempFloor

var enemy_dms_app = preload("res://hud_elements/app_screens/enemy_dms.tscn")

func kill_panos():
	left_pano.queue_free()
	right_pano.queue_free()

func on_ontro_done():
	var timer_time = 1.1
	
	var tLeftRot = get_tree().create_tween()
	tLeftRot.tween_property(left_pano, "rotation", Vector3(0.0, 0.0, PI * -0.5), timer_time)
	var tRightRot = get_tree().create_tween()
	tRightRot.tween_property(right_pano, "rotation", Vector3(0.0, 0.0, PI * 0.5), timer_time)
	
	var tleftPos = get_tree().create_tween()
	tleftPos.tween_property(left_pano, "translation", Vector3(15.0, -30.0, 0.0), timer_time).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
	var tRightPos = get_tree().create_tween()
	tRightPos.tween_property(right_pano, "translation", Vector3(-15.0, -30.0, 0.0), timer_time).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
	
	var _kill_panos_connect = get_tree().create_timer(timer_time, false).connect("timeout", self, "kill_panos")
	
	temp_loor.queue_free()
	
	subscreen.show_camera_screen()

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

