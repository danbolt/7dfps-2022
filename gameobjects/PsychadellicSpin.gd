extends MeshInstance

func _ready():
	visible = false
	
	yield(get_tree().create_timer(3.0, false), "timeout")
	
	visible = true

func _process(delta):
	global_rotate((Vector3.UP + Vector3.RIGHT).normalized(), delta)
