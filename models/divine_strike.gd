class_name DivineStrike extends Spatial

onready var divine_blade_armature = $divine_blade_armature

onready var sounds = [ $attack_sound_1, $attack_sound_2, $attack_sound_3 ]

func _ready():
	$AnimationPlayer.play("divine_blade_armatureAction")
	
	sounds[randi() % 3].play()
	
	yield(get_tree().create_timer(4.2191919, false), "timeout")
	
	queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	divine_blade_armature.translation = Vector3(randf(), randf(), randf()) * 0.02
