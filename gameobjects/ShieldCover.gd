class_name ShieldCover extends StaticBody

export var covered_by: NodePath

onready var line_geo = $ImmediateGeometry

func _physics_process(_delta):
	if (covered_by.is_empty()):
		queue_free()
		return
	
	var node_covered_by = get_node_or_null(covered_by)
	if node_covered_by == null:
		queue_free()
		
func _process(_delta):
	line_geo.global_rotation = Vector3.ZERO
	line_geo.clear()
	
	if (covered_by.is_empty()):
		return
	
	var node_covered_by = get_node_or_null(covered_by) as Spatial
	if node_covered_by == null:
		return
		
	line_geo.begin(Mesh.PRIMITIVE_LINES)
		
	# Call last for each vertex, adds the above attributes.
	line_geo.add_vertex(Vector3.ZERO)

	line_geo.add_vertex(node_covered_by.global_translation - global_translation)

	# End drawing.
	line_geo.end()

func _ready():
	line_geo.scale = (scale as Vector3).inverse()
	
