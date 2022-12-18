class_name NISCamera extends Camera


export var boss: NodePath

export var pointA: NodePath
export var pointB: NodePath

export var turn_time: float = 4.0
export var wait_time: float = 2.0

onready var audio = $AudioStreamPlayer

signal done_nis()

func _process(_delta):
	var bossToView: Spatial = get_node_or_null(boss) as Spatial
	if (bossToView == null):
		queue_free()
		return
	
	look_at(bossToView.global_translation, Vector3.UP)

func fire_NIS():
	var pointASpot: Spatial = get_node(pointA) as Spatial
	var pointBSpot: Spatial = get_node(pointB) as Spatial
	
	audio.play()
	
	var oldCamera: Camera = get_viewport().get_camera()
	
	global_translation = pointASpot.global_translation
	var t = get_tree().create_tween()
	t.tween_property(self, "global_translation", pointBSpot.global_translation, turn_time).set_trans(Tween.TRANS_CUBIC)
	
	self.make_current()
	
	get_tree().call_group("listen_for_title", "show_subtitle_text", "Alright nerd, this is the end of the line.")
	
	yield(get_tree().create_timer(2.89, false), "timeout")
	
	get_tree().call_group("listen_for_title", "show_subtitle_text", "Nobody sees Lord Dracula without the offer of a buyout.")
	
	yield(get_tree().create_timer(wait_time + turn_time - 2.89, false), "timeout")
	
	oldCamera.make_current()
	
	get_tree().call_group("listen_for_title", "hide_subttitle_text")
	
	emit_signal("done_nis")

func _ready():
	#fire_NIS()
	pass
