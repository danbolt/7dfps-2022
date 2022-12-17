class_name NISCamera extends Camera


export var boss: NodePath

export var pointA: NodePath
export var pointB: NodePath

export var turn_time: float = 4.0
export var wait_time: float = 1.0

signal done_nis()

func _process(_delta):
	var bossToView: Spatial = get_node(boss) as Spatial
	look_at(bossToView.global_translation, Vector3.UP)

func fire_NIS():
	var pointASpot: Spatial = get_node(pointA) as Spatial
	var pointBSpot: Spatial = get_node(pointB) as Spatial
	
	var oldCamera: Camera = get_viewport().get_camera()
	
	global_translation = pointASpot.global_translation
	var t = get_tree().create_tween()
	t.tween_property(self, "global_translation", pointBSpot.global_translation, turn_time).set_trans(Tween.TRANS_CUBIC)
	
	self.make_current()
	
	yield(get_tree().create_timer(wait_time + turn_time, false), "timeout")
	
	oldCamera.make_current()
	
	emit_signal("done_nis")

func _ready():
	#fire_NIS()
	pass
