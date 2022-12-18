class_name AttackGoblin extends Enemy

var current_velocity = Vector3.ZERO

onready var hurtbox = $DemonHurtbox

var dying: bool = false
	
var chasing: bool = false
var chasing_player: Spatial = null
var chase_repath_time: float = 0.0

onready var navigation_agent: NavigationAgent = $NavigationAgent

onready var animation_player: AnimationPlayer = $attack_goblin_base/AnimationPlayer


onready var death_sound = $death_sound
onready var forget_sound = $forget_sound
onready var notice_sound = $notice_sound

const DOT_FOV_ANGLE = 0.501
const DOT_FOV_ANGLE_SUSTAIN = 0.301

const RUN_SPEED = 5.45

func on_animation_done(animation_name):
	if (animation_name != "die"):
		return
		
	yield(get_tree().create_timer(0.25), "timeout")
	
	emit_signal("died")
	

func on_struck(_hurtbox):
	if dying:
		return
	
	dying = true
	hurtbox.queue_free()
	
	death_sound.play()
	
	animation_player.play("die")
	
	var _connect_to_anim_finish = animation_player.connect("animation_finished", self, "on_animation_done")
	
func _process(_delta):
	if dying:
		return
	
	if not chasing:
		animation_player.play("idle")
	elif chasing and not animation_player.is_playing():
		animation_player.play("run")

func _physics_process(delta):
	if dying:
		return
		
	
	var ourForward: Vector3 = global_transform.basis.z
	if not chasing:
		var all_players: Array = get_tree().get_nodes_in_group("player_character")
		for player in all_players:
			var directionToPlayer: Vector3 = ((player as Spatial).global_translation - global_translation).normalized()
			var angleRatio = ourForward.dot(directionToPlayer * -1)
			if angleRatio > DOT_FOV_ANGLE and has_los(player):
				chasing = true
				chasing_player = player
				chase_repath_time = 0.0
				navigation_agent.set_target_location(chasing_player.global_translation)
				animation_player.play("alert")
				look_at(chasing_player.global_translation, Vector3.UP)
				notice_sound.play()
				break
	else:
		var directionToPlayer: Vector3 = ((chasing_player as Spatial).global_translation - global_translation).normalized()
		var distanceToPlayerSquared: float = ((chasing_player as Spatial).global_translation).distance_squared_to(global_translation)
		var angleRatio = ourForward.dot(directionToPlayer * -1)
		if  (distanceToPlayerSquared > (6.0 * 6.0) and (angleRatio < DOT_FOV_ANGLE_SUSTAIN - 0.3)) or angleRatio < DOT_FOV_ANGLE_SUSTAIN or not has_los(chasing_player):
			chasing = false
			chasing_player = null
			forget_sound.play()
		
	
	var moveDirection = Vector3.ZERO
	if (chasing and animation_player.current_animation != "alert"):
		look_at(chasing_player.global_translation, Vector3.UP)
		
		var distanceToPlayerSquared: float = ((chasing_player as Spatial).global_translation).distance_squared_to(global_translation)
		if distanceToPlayerSquared > 6.0 * 6.0:
			chase_repath_time += delta
			if chase_repath_time > 1.1 + randf() * 0.3:
				navigation_agent.set_target_location(chasing_player.global_translation)
				
			var nextSpotToWalkTo = navigation_agent.get_next_location()
			look_at(nextSpotToWalkTo, Vector3.UP)
			moveDirection = (nextSpotToWalkTo - global_translation).normalized()
		else:
			look_at((chasing_player as Spatial).translation, Vector3.UP)
			moveDirection = ((chasing_player as Spatial).global_translation - global_translation).normalized()
		
	
	var gravityValue = Vector3.DOWN * 5 if not is_on_floor() else Vector3.ZERO
	current_velocity = move_and_slide(gravityValue + (moveDirection * RUN_SPEED), Vector3.UP)
	
	global_rotation = Vector3(0.0, global_rotation.y, 0.0)
	
func _ready():
	current_velocity = Vector3.ZERO
	dying  = false
	chasing = false
	chasing_player = null
	chase_repath_time = 0.0
	
	navigation_agent.set_target_location(transform.origin)
	
	var _connect_struck_result = connect("been_struck", self, "on_struck")
