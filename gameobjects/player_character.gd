class_name PlayerMovement extends KinematicBody

onready var camera = $Camera

onready var subscreen: Spatial = $Camera/Subscreen

const held_up_transform = Transform(Vector3(0.978, 0.21, 0.0), Vector3(-0.21, 0.978, 0.0), Vector3(0, 0, 1), Vector3(0.207, -0.24, -1.256))
const held_down_transform = Transform(Vector3(0.473, 0.031, 0.439), Vector3(0.398, 0.14, -0.439), Vector3(-0.096, 0.489, 0.069), Vector3(0.392, -0.372, 0.03))
var subscreen_held_state: float = 0.0

const BESPOKE_MOUSE_SENSITIVITY_MODIFIER = 2.0

export var movement_speed: float = 5.216
export var turn_speed: float = 0.07125

var move_speed: Vector3 = Vector3.ZERO

var mouse_move_accumulation: Vector2 = Vector2.ZERO

# This is used for mouselook 
func _input(event):
	if (not event is InputEventMouseMotion):
		return
	mouse_move_accumulation += (event as InputEventMouseMotion).relative * BESPOKE_MOUSE_SENSITIVITY_MODIFIER

func _physics_process(_delta):
	subscreen.transform = held_down_transform.interpolate_with(held_up_transform, subscreen_held_state)
	subscreen_held_state = lerp(subscreen_held_state, Input.get_action_strength("ads"), 0.183)
	
	var player_settings = get_node("/root/PlayerSettings")
	
	var y_invert = player_settings.get_y_invert()
	
	var x_sensitivity_modifier: float = player_settings.get_x_sensitivity() * 0.07
	var y_sensitivity_modifier: float = player_settings.get_y_sensitivity() * 0.07
	
	var moveVector = Vector2(Input.get_axis("step_left", "step_right"), Input.get_axis("step_backward", "step_forward"))
	var turnVector = Vector2(Input.get_axis("turn_left", "turn_right"), Input.get_axis("turn_down", "turn_up"))
	
	# Turn the camera
	camera.global_rotate(Vector3.UP, turnVector.x * -1.0 * (turn_speed + x_sensitivity_modifier))
	camera.global_rotate(camera.transform.basis.x, turnVector.y * (turn_speed + y_sensitivity_modifier) * (-1.0 if y_invert else 1.0 ))
	
	# Mouselook for camera turning
	if (not mouse_move_accumulation.is_equal_approx(Vector2.ZERO)):
		var converted_movement = Vector2(deg2rad(mouse_move_accumulation.x), deg2rad(mouse_move_accumulation.y))
		camera.global_rotate(Vector3.UP, converted_movement.x * -1.0 * (turn_speed + x_sensitivity_modifier))
		camera.global_rotate(camera.transform.basis.x, converted_movement.y * (turn_speed + y_sensitivity_modifier) * (1.0 if y_invert else -1.0))
		mouse_move_accumulation = Vector2.ZERO
		
	camera.global_rotation.x = min(max(camera.global_rotation.x, -1.3), 1.3)
	camera.rotation.z = 0.0
	
	# Move based on the camera's direction
	var camera_forward = camera.transform.basis.z * -1.0
	var camera_right = camera.transform.basis.x
	var stepDirection = ((camera_forward * moveVector.y) + (camera_right * moveVector.x))
	stepDirection.y = 0.0
	stepDirection = stepDirection.normalized()
	var playerMovement = stepDirection * movement_speed
	
	var gravityValue = (Vector3.DOWN * 0.3) if not is_on_floor() else Vector3.ZERO
	var verticalMovement = Vector3(0.0, move_speed.y, 0.0)
	verticalMovement += gravityValue
	if (is_on_floor() and Input.is_action_pressed("jump")):
		verticalMovement.y = 10.0
	
	move_speed = move_and_slide(playerMovement + verticalMovement, Vector3.UP)

func _ready():
	move_speed = Vector3.ZERO
	
	mouse_move_accumulation = Vector2.ZERO
	
	subscreen_held_state = 0.0
	
