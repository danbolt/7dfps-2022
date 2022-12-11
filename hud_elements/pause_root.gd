class_name PauseRoot extends Control

onready var alpha_backing: ColorRect = $alpha_backing

onready var top_decorator: TextureRect = $Top/TopDecorator
onready var bottom_decorator: TextureRect = $Bottom/BottomDecorator

onready var top: Control = $Top
onready var bottom: Control = $Bottom

signal done_exiting()

func indicate_done():
	emit_signal("done_exiting")

func decorators_in():
	top.rect_position = Vector2(0.0, -64.0)
	var ttop = get_tree().create_tween()
	ttop.tween_property(top, "rect_position", Vector2(0.0, 0.0), 0.315).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC).set_delay(0.2)
	ttop.bind_node(top)
	
	bottom.rect_position = Vector2(0.0, 64.0)
	var tbottom = get_tree().create_tween()
	tbottom.tween_property(bottom, "rect_position", Vector2(0.0, 0.0), 0.315).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC).set_delay(0.2)
	tbottom.bind_node(bottom)
	
	alpha_backing.rect_position = Vector2(0.0, -720)
	var talpha = get_tree().create_tween()
	talpha.tween_property(alpha_backing, "rect_position", Vector2(0.0, 0.0), 0.5181).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	talpha.bind_node(alpha_backing)
	
func decorators_out():
	var ttop = get_tree().create_tween()
	ttop.tween_property(top, "rect_position", Vector2(0.0, -64), 0.27)
	ttop.bind_node(top)
	
	var tbottom = get_tree().create_tween()
	tbottom.tween_property(bottom, "rect_position", Vector2(0.0, 64), 0.27)
	tbottom.bind_node(bottom)
	
	var talpha = get_tree().create_tween()
	talpha.tween_property(alpha_backing, "rect_position", Vector2(0.0, 1080.0), 0.6).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	talpha.bind_node(alpha_backing)
	var _connect_result = talpha.connect("finished", self, "indicate_done")

func _ready():
	pass # Replace with function body.

func _process(delta):
	top_decorator.rect_position.x += delta * 100.0
	if (top_decorator.rect_position.x > 0):
		top_decorator.rect_position.x -= 64
	
	bottom_decorator.rect_position.x += delta * 100.0
	if (bottom_decorator.rect_position.x > 0):
		bottom_decorator.rect_position.x -= 64
