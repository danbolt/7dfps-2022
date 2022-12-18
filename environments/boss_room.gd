extends Spatial

onready var nis = $NISCamera
onready var psych_spin: PsychadellicSpin = $PsychadellicSpin

onready var boss: Carmilla = $Carmilla

onready var entry_nis_shape: Area = $entry_nis_shape

onready var bgm = $intro_bgm

func on_player_enter(_hitbox):
	bgm.play()
	
	boss.disconnect("been_struck", self, "on_boss_struck")
	entry_nis_shape.disconnect("body_entered", self, "on_player_enter")
	
	if nis == null:
		return
	
	nis.fire_NIS()
	yield(get_tree().create_timer(nis.turn_time + nis.wait_time - 1.0, false), "timeout")
	
	get_tree().call_group("listen_for_title", "show_title_text", "Carmilla")
	
	psych_spin.visible = true
	
	entry_nis_shape.queue_free()
	

func on_done_nis():
	yield(get_tree().create_timer(1.75, false), "timeout")
	get_tree().call_group("listen_for_title", "hide_title_text")
	
func on_boss_struck(_hitbox):
	if entry_nis_shape == null:
		return
		
	entry_nis_shape.queue_free()

func _ready():
	psych_spin.visible = false
	
	var _boss_strike_connect = boss.connect("been_struck", self, "on_boss_struck")
	
	var _player_entry = entry_nis_shape.connect("body_entered", self, "on_player_enter")
	
	var _done_nis_signal = nis.connect("done_nis", self, "on_done_nis")
