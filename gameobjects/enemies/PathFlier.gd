class_name PathFlier extends Enemy

export var route_path:NodePath

var current_fly_index: int = 0

export var fly_speed:float  = 2.0

func on_struck(_hurtbox):
	emit_signal("died")


func _ready():
	current_fly_index = 0
	
	var _connect_struck_result = connect("been_struck", self, "on_struck")



func _physics_process(_delta):
	if route_path.is_empty():
		return
	
	var path_to_walk: Path = get_node(route_path) as Path
	
	var next_point: Vector3 = path_to_walk.curve.get_point_position(current_fly_index)
	if (next_point.distance_squared_to(global_translation) <= 1.0):
		current_fly_index = (current_fly_index + 1) % path_to_walk.curve.get_point_count()
	
	var directionToNextPoint: Vector3 = (next_point - global_translation).normalized()
	
	var _move_slide_result = move_and_slide(directionToNextPoint * fly_speed, Vector3.UP)
	look_at(next_point, Vector3.UP)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
