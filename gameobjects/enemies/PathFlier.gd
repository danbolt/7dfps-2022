class_name PathFlier extends Enemy


export var spots_to_fly_between: Array = []
var current_fly_index: int = 0

export var fly_speed:float  = 2.0

func on_struck(_hurtbox):
	emit_signal("died")


func _ready():
	current_fly_index = 0
	
	var _connect_struck_result = connect("been_struck", self, "on_struck")



func _physics_process(_delta):
	move_and_slide(Vector3.RIGHT, Vector3.UP)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
