class_name Carmilla extends Enemy

onready var animation_player: AnimationPlayer = $carmilla/AnimationPlayer

onready var hurtbox = $hurtbox

var dying: bool = false

var current_velocty: Vector3 = Vector3.ZERO

onready var sfx = $attack_sound

onready var projecile_prefab = preload("res://gameobjects/EnemyProjectile.tscn")

func on_finish_magic_anim(anim_name):
	if anim_name != "magic":
		return
		
	for x in range(-20, 21):
		for y in range(-11, 29):
			if randf() > 0.05:
				continue
			
			var new_proj: EnemyProjectile = projecile_prefab.instance()
			get_parent().add_child(new_proj)
			new_proj.global_translation = Vector3(x, 14 + randf() * 2.0, y)
			new_proj.fly_dir = Vector3.DOWN
			new_proj.fly_speed = 1.5 + randf() * 0.5
			
	
	yield(get_tree().create_timer(10.0, false), "timeout")
	
	mystic_attack()
	

func mystic_attack():
	if dying:
		return
	
	animation_player.play("magic")
	sfx.stop()
	sfx.play()

func on_animation_done(animation_name):
	if (animation_name != "die"):
		return
		
	yield(get_tree().create_timer(0.25), "timeout")
	
	emit_signal("died")
	

func on_struck(_hurtbox):
	if dying:
		return
		
	sfx.stop()
	
	dying = true
	hurtbox.queue_free()
	
	animation_player.play("die")
	
	var _connect_to_anim_finish = animation_player.connect("animation_finished", self, "on_animation_done")
	
	
func _physics_process(_delta):
	if (dying):
		return
		
	
	if (animation_player.current_animation != "magic"):
		animation_player.play("idle")
	
func _ready():
	current_velocty = Vector3.ZERO
	dying  = false
	
	var _connect_to_anim = animation_player.connect("animation_finished", self, "on_finish_magic_anim")
	
	var shield = get_node_or_null("ShieldCover")
	if shield != null:
		shield.scale = Vector3(0.0001, 0.0001, 0.0001)
	
	var _connect_struck_result = connect("been_struck", self, "on_struck")
