class_name ShieldCover extends StaticBody

export var covered_by: NodePath

onready var line_geo = $ImmediateGeometry


onready var t = 0

func _physics_process(_delta):
	if (covered_by.is_empty()):
		queue_free()
		return
	
	var node_covered_by = get_node_or_null(covered_by)
	if node_covered_by == null:
		queue_free()
		
func _process(delta):
	line_geo.scale = (scale as Vector3).inverse()
	line_geo.global_rotation = Vector3.ZERO
	line_geo.clear()
	
	if (covered_by.is_empty()):
		return
	
	var node_covered_by = get_node_or_null(covered_by) as Spatial
	if node_covered_by == null:
		return
		
	line_geo.begin(Mesh.PRIMITIVE_LINES)
	
	var count = 16 + (int(t) % 8)
	t += delta * 32
	if (t >= 9.0):
		t = 0
	
	for i in range(0, count):
		line_geo.add_vertex(lerp(global_translation, node_covered_by.global_translation, float(i) / float(count)) - global_translation)

	line_geo.add_vertex(node_covered_by.global_translation - global_translation)

	# End drawing.
	line_geo.end()

func _ready():
	pass
	
