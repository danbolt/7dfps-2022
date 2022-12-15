class_name PathFlierShooter extends Enemy

export var route_path:NodePath

var current_fly_index: int = 0

export var fly_speed:float  = 2.0

onready var animation_player: AnimationPlayer = $mesh/AnimationPlayer

onready var hurtbox = $DemonSphereHurtbox

var dying: bool = false

var shooting_at: Spatial = null

const DOT_FOV_ANGLE = 0.51

onready var projectile = preload("res://gameobjects/EnemyProjectile.tscn")

var shot_time = 0.0

func on_animation_done(_animation_name):
	emit_signal("died")
	

func on_struck(_hurtbox):
	if dying:
		return
	
	hurtbox.queue_free()
	
	dying = true
	
	animation_player.play("die")
	
	var _connect_to_anim_finish = animation_player.connect("animation_finished", self, "on_animation_done")
	


func _ready():
	current_fly_index = 0
	dying = false
	shooting_at = null
	
	shot_time = 0.0 + randf()
	
	var _connect_struck_result = connect("been_struck", self, "on_struck")

func _process(_delta):
	if (dying):
		animation_player.playback_speed = 1.0
		return
		
	animation_player.play("idle")

func _physics_process(delta):
	if dying:
		return
	
	if shooting_at == null:
		var all_players: Array = get_tree().get_nodes_in_group("player_character")
		for player in all_players:
			var directionToPlayer: Vector3 = ((player as Spatial).global_translation - global_translation).normalized()
			if global_transform.looking_at((player as Spatial).global_translation, Vector3.UP) and has_los(player):
				shooting_at = player
				look_at(global_translation - (directionToPlayer), Vector3.UP)
	else:
		if global_transform.looking_at(shooting_at.global_translation, Vector3.UP) or (not has_los(shooting_at)):
			shooting_at = null
			animation_player.playback_speed = 0.25
		else:
			look_at(shooting_at.global_translation, Vector3.UP)
			
	if (shooting_at != null):
		animation_player.playback_speed = 2.0
		shot_time += delta
		if (shot_time > 1.0):
			var new_proj: EnemyProjectile = projectile.instance()
			get_parent().add_child(new_proj)
			new_proj.global_translation = global_translation
			new_proj.fly_dir = (shooting_at.global_translation - global_translation).normalized()
			new_proj.fly_speed = 3.0
			shot_time = 0.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
