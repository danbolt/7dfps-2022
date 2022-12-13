class_name DivineStrike extends Spatial

onready var divine_blade_armature = $divine_blade_armature

func _ready():
	$AnimationPlayer.play("divine_blade_armatureAction")
	
	yield(get_tree().create_timer(4.2191919, false), "timeout")
	
	queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	divine_blade_armature.translation = Vector3(randf(), randf(), randf()) * 0.02
