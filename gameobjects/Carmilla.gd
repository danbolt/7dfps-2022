class_name Carmilla extends Enemy

onready var animation_player = $carmilla/AnimationPlayer

onready var hurtbox = $hurtbox

var dying: bool = false

var current_velocty: Vector3 = Vector3.ZERO

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
	
	animation_player.play("die")
	
	var _connect_to_anim_finish = animation_player.connect("animation_finished", self, "on_animation_done")
	
	
func _physics_process(_delta):
	if (dying):
		return
	
	animation_player.play("idle")
	
	
func _ready():
	current_velocty = Vector3.ZERO
	dying  = false
	
	var _connect_struck_result = connect("been_struck", self, "on_struck")
