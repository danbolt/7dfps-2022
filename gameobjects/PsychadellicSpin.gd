class_name PsychadellicSpin extends MeshInstance

func _ready():
	visible = false

func _process(delta):
	global_rotate((Vector3.UP + Vector3.RIGHT).normalized(), delta)
