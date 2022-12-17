class_name PlayerApps extends Spatial

onready var camera_screen = $CameraScreen
onready var other_apps_screen = $OtherAppsScreen

onready var other_apps_control = $Viewport2/Camera/Apps

onready var target_info_text = $CameraScreen/TargetInfoText
onready var target_data_text = $CameraScreen/TargetDataText

onready var no_target_text = $CameraScreen/NoTargetText
onready var target_found_text = $CameraScreen/TargetLocatedText
onready var divine_strike_text = $CameraScreen/DivineStrikeText

onready var bar_fill_percentage: float = 0.0
onready var current_hurtbox: DemonHurtbox = null

onready var progress_bar_backing = $CameraScreen/ProgressbarBacking
onready var progress_bar: Spatial = $CameraScreen/ProgressBar
onready var crosshairs: Spatial = $CameraScreen/Crosshairs

onready var offlight: Spatial = $PhoneBody/OffLight
onready var onlight: Spatial = $PhoneBody/Onlight

onready var subcamera: Spatial = $Viewport/SubCamera

onready var phone_vibrate_audio = $PhoneVibrate
onready var stuck_noise_audio = $StuckNoise

onready var charge_sfx = $ChargeSound

onready var lock_on_sound = $LockOnSound
onready var lock_off_sound = $LockOffSound
onready var fire_sound = $FireSound

onready var divine_strike_prefab = preload("res://models/divine_strike.tscn")

func show_other_app_screen():
	camera_screen.visible = false
	other_apps_screen.visible = true
	
func show_camera_screen():
	camera_screen.visible = true
	other_apps_screen.visible = false
	
func instance_other_app(otherApp: PackedScene) -> Control:
	for child in other_apps_control.get_children():
		other_apps_control.queue_free()
	
	var newApp = otherApp.instance()
	other_apps_control.add_child(newApp)
	
	return newApp as Control
	
func play_vibrate_sound():
	phone_vibrate_audio.play()
	
func play_stuck_noise():
	stuck_noise_audio.play()

func _ready():
	
	other_apps_screen.visible = false
	
	target_found_text.visible = false
	no_target_text.visible = true
	target_info_text.visible = true
	target_data_text.visible = false
	
	progress_bar_backing.visible = false
	progress_bar.visible =false
	
	divine_strike_text.visible = false
	
	onlight.visible = false
	
	bar_fill_percentage = 0.0
	current_hurtbox = null
	
func _physics_process(delta):
	
	if camera_screen.visible:
		var space_state = get_world().direct_space_state
		var result = space_state.intersect_ray(subcamera.global_translation + subcamera.global_transform.basis.z * 2.5, subcamera.global_translation + subcamera.global_transform.basis.z * -100, [], 2)
		
		if current_hurtbox == null and result and (result.collider is DemonHurtbox):
			current_hurtbox = result.collider as DemonHurtbox
			bar_fill_percentage = 0.0
			progress_bar_backing.scale = Vector3(1.0, 0.0, 1.0)
			
			target_data_text.text = (result.collider as DemonHurtbox).identifier
			
			var t = get_tree().create_tween()
			t.tween_property(progress_bar_backing, "scale", Vector3.ONE, 0.161)
			
			target_found_text.scale = Vector3(0.059, 0, 0.064)
			var t2 = get_tree().create_tween()
			t2.tween_property(target_found_text, "scale", Vector3(0.059, 0.027, 0.064), 0.161)
			
			lock_on_sound.play()
		elif current_hurtbox != null and result and result.collider != current_hurtbox:
			current_hurtbox = null
		elif current_hurtbox != null and result and result.collider == current_hurtbox:
			# looking at the same demon; no need to do anything
			pass
		elif current_hurtbox != null and !result:
			current_hurtbox = null
			lock_off_sound.play()
		else: 
			current_hurtbox = null
			
		
		if current_hurtbox != null and (Input.is_action_pressed("fire")):
			bar_fill_percentage += delta * 0.24
			
			if not charge_sfx.playing:
				charge_sfx.play()
			charge_sfx.pitch_scale = bar_fill_percentage + 1.0
			
			if (bar_fill_percentage >= 1.0):
				current_hurtbox.strike()
				fire_sound.pitch_scale = 2.0
				fire_sound.play()
				
				var divine_strike_anim = divine_strike_prefab.instance()
				
				# HACK: add this a better way
				get_parent().get_parent().get_parent().add_child(divine_strike_anim)
				
				onlight.visible = true
				
				divine_strike_anim.global_translation = current_hurtbox.global_translation
				divine_strike_anim.look_at(global_translation, Vector3.UP)
				
				divine_strike_text.visible = true
				var _timeout_connect_val = get_tree().create_timer(0.7, false).connect("timeout", self, "on_divine_strike_timeout_done")
		elif current_hurtbox != null and (not Input.is_action_pressed("fire")):
			bar_fill_percentage -= delta * 0.811
			bar_fill_percentage = max(0.0, bar_fill_percentage)
	
	
func on_divine_strike_timeout_done():
	divine_strike_text.visible = false
	onlight.visible = false
	
func _process(_delta):
	
	if current_hurtbox != null:
		target_found_text.visible = true
		no_target_text.visible = false
		target_info_text.visible = false
		target_data_text.visible = true
		
		progress_bar_backing.visible = true
		progress_bar.visible = true
	else:
		target_found_text.visible = false
		target_data_text.visible = false
		if not divine_strike_text.visible:
			no_target_text.visible = true
			target_info_text.visible = true
		
		progress_bar_backing.visible = false
		progress_bar.visible =false
		
	offlight.visible = !onlight.visible
		
	var inv_bar_fill = 1.0 - bar_fill_percentage
	var inv_cubic_bar_fill_percentage = (1.0 - (inv_bar_fill * inv_bar_fill * inv_bar_fill))
	progress_bar.scale = Vector3( inv_cubic_bar_fill_percentage * 10.0, 1.0, 1.0)
		
