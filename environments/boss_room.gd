extends Spatial

onready var nis: NISCamera = $NISCamera
onready var psych_spin: PsychadellicSpin = $PsychadellicSpin

onready var entry_nis_shape: Area = $entry_nis_shape

func on_player_enter(_hitbox):
	nis.fire_NIS()
	yield(get_tree().create_timer(nis.turn_time, false), "timeout")
	
	get_tree().call_group("listen_for_title", "show_title_text", "Carmilla")
	
	psych_spin.visible = true
	
	entry_nis_shape.queue_free()
	

func on_done_nis():
	yield(get_tree().create_timer(1.75, false), "timeout")
	get_tree().call_group("listen_for_title", "hide_title_text")

func _ready():
	psych_spin.visible = false
	
	var _player_entry = entry_nis_shape.connect("body_entered", self, "on_player_enter")
	
	var _done_nis_signal = nis.connect("done_nis", self, "on_done_nis")
