class_name EnemyProjectile extends Area

export var fly_speed:float = 1.0

export var fly_dir: Vector3 = Vector3.FORWARD

export var fly_speed_mod_per_tick: float = 1.0

onready var innermesh = $innermesh
onready var outline = $outline

func on_hit_wall(_hitbox):
	queue_free()

func _physics_process(delta):
	global_translation += (fly_dir * fly_speed * delta)
	
	fly_speed *= fly_speed_mod_per_tick
	fly_speed = max(0.3, fly_speed)
	
func _process(_delta):
	innermesh.rotation = Vector3(randf(), randf(), randf()) * PI * 2.0
	
	var scaleValue = sin(Time.get_ticks_msec()) * 0.025
	outline.scale = Vector3(scaleValue, scaleValue, scaleValue) + Vector3.ONE

func _ready():
	var _connect_result = connect("body_exited", self, "on_hit_wall")
