extends Spatial

onready var camera_screen = $CameraScreen
onready var other_apps_screen = $OtherAppsScreen

func process_next_app():
	if camera_screen.visible:
		camera_screen.visible = false
		other_apps_screen.visible = true
	elif other_apps_screen.visible:
		camera_screen.visible = true
		other_apps_screen.visible = false
	

func _ready():
	other_apps_screen.visible = false
	
func _process(_delta):
	if Input.is_action_just_released("next_app") or Input.is_action_just_released("prev_app"):
		process_next_app()
		
	if Input.is_action_just_pressed("fire"):
		if (camera_screen.visible):
			var space_state = get_world().direct_space_state
			
			var result = space_state.intersect_ray(global_translation, global_transform.basis.z * -100, [], 2)
			if result:
				print(result.collider)
			else:
				print("no hit")
