extends Spatial

onready var camera_screen = $CameraScreen
onready var other_apps_screen = $OtherAppsScreen

onready var target_info_text = $CameraScreen/TargetInfoText
onready var target_data_text = $CameraScreen/TargetDataText

onready var no_target_text = $CameraScreen/NoTargetText
onready var target_found_text = $CameraScreen/TargetLocatedText

func process_next_app():
	if camera_screen.visible:
		camera_screen.visible = false
		other_apps_screen.visible = true
	elif other_apps_screen.visible:
		camera_screen.visible = true
		other_apps_screen.visible = false
	

func _ready():
	other_apps_screen.visible = false
	
	target_found_text.visible = false
	no_target_text.visible = true
	target_info_text.visible = true
	target_data_text.visible = false
	
func _process(_delta):
	if Input.is_action_just_released("next_app") or Input.is_action_just_released("prev_app"):
		process_next_app()
		
	var space_state = get_world().direct_space_state
	var result = space_state.intersect_ray(global_translation, global_transform.basis.z * -100, [], 2)
	if result:
		target_found_text.visible = true
		no_target_text.visible = false
		target_info_text.visible = false
		target_data_text.visible = true
	else:
		target_found_text.visible = false
		no_target_text.visible = true
		target_info_text.visible = true
		target_data_text.visible = false
