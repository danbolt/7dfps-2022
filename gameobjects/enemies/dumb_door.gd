class_name DumbDoor extends Enemy

onready var animation_player: AnimationPlayer = $dumbdoor/AnimationPlayer

onready var boxbody = $BoxBody
onready var hurtbox = $DemonSphereHurtbox

var dying: bool = false

func on_struck(_hurtbox):
	if dying:
		return
	
	dying = true
	hurtbox.queue_free()
	boxbody.queue_free()
	
	yield(get_tree().create_timer(1.25), "timeout")
	
	emit_signal("died")

func _physics_process(delta):
	if dying:
		rotate_y(20.0 * delta)

func _process(_delta):
	animation_player.play("idle")
	
func _ready():
	var _connect_struck_result = connect("been_struck", self, "on_struck")
