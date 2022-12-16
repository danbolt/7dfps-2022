class_name EnemyDMs extends Control


signal done()

onready var brandenburg3 = $brandenburg3
onready var intro_spiel = $intro_spiel

onready var stuck_logo = $StuckLogo

onready var side_bar = $DmBit/SideBar


onready var dracula_avi = $DraculaAvi


onready var texts: Control = $DmBit/Texts

func play_evil_dracula_intro():
	brandenburg3.play()
	
	yield(get_tree().create_timer(0.8, false), "timeout")
	
	var tLogo = get_tree().create_tween()
	tLogo.tween_property(stuck_logo, "scale", Vector2(0.353, 0.0), 0.9).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
	
	yield(get_tree().create_timer(0.8, false), "timeout")
	
	var tAvi = get_tree().create_tween()
	tAvi.tween_property(dracula_avi, "position", Vector2(248, 80), 1.8).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUAD)
	
	var tSide = get_tree().create_tween()
	tSide.tween_property(side_bar, "rect_size", Vector2(164, 1920), 1.8).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
	
	yield(get_tree().create_timer(2.0, false), "timeout")
	
	for child in texts.get_children():
		var t = get_tree().create_timer((child as DM).delay, false)
		var _timeoutConnect = t.connect("timeout", child as Control, "show")
	
	intro_spiel.play()
	
	yield(intro_spiel, "finished")
	
	var t = get_tree().create_tween()
	t.tween_property(brandenburg3, "volume_db", -80.0, 5.0)
	
	yield(get_tree().create_timer(6.0, false), "timeout")
	
	emit_signal("done")
	
	

func _ready():
	side_bar.rect_size.x = 0.0
	
	dracula_avi.position.y = -100
	
	for child in texts.get_children():
		child.visible = false
