class_name Curtains extends Control

const CLOSE_TIME: float = 0.5
const OPEN_TIME: float = 0.6484848

const OPEN_SIZE: Vector2 = Vector2(0, 1080)
const CLOSE_SIZE: Vector2 = Vector2(960, 1080)

onready var left_curtain: ColorRect = $left_curtain
onready var right_curtain: ColorRect = $right_curtain

signal finished_closing()
signal finished_opening()

export var is_moving = false

func open_curtains():
	assert(!is_moving)
	
	is_moving = true
	
	var tleft = get_tree().create_tween()
	tleft.set_pause_mode(Tween.PAUSE_MODE_PROCESS)
	tleft.tween_property(left_curtain, "rect_size", OPEN_SIZE, OPEN_TIME)
	tleft.set_ease(Tween.EASE_OUT)
	tleft.set_trans(Tween.TRANS_CUBIC)
	
	var tright = get_tree().create_tween()
	tright.set_pause_mode(Tween.PAUSE_MODE_PROCESS)
	tright.tween_property(right_curtain, "rect_size", OPEN_SIZE, OPEN_TIME)
	tright.set_ease(Tween.EASE_OUT)
	tright.set_trans(Tween.TRANS_CUBIC)
	
	yield(get_tree().create_timer(OPEN_TIME), "timeout")
	
	is_moving = false
	emit_signal("finished_opening")
	
func close_curtains():
	assert(!is_moving)
	
	is_moving = true
	
	var tleft = get_tree().create_tween()
	tleft.tween_property(left_curtain, "rect_size", CLOSE_SIZE, CLOSE_TIME)
	tleft.set_ease(Tween.EASE_IN)
	tleft.set_trans(Tween.TRANS_CUBIC)
	
	var tright = get_tree().create_tween()
	tright.tween_property(right_curtain, "rect_size", CLOSE_SIZE, CLOSE_TIME)
	tright.set_ease(Tween.EASE_IN)
	tright.set_trans(Tween.TRANS_CUBIC)
	
	yield(get_tree().create_timer(CLOSE_TIME), "timeout")
	
	is_moving = false
	emit_signal("finished_closing")

# Called when the node enters the scene tree for the first time.
func _ready():
	left_curtain.rect_size = CLOSE_SIZE
	right_curtain.rect_size = CLOSE_SIZE


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
