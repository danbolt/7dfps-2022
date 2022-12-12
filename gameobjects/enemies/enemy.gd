class_name Enemy extends Node

signal been_struck(hurtbox)

signal died()

func on_died():
	queue_free()

func on_hurtbox_struck(hurtbox: DemonHurtbox):
	emit_signal("been_struck", hurtbox)
	
	# TODO: Let something else handle this
	emit_signal("died")

# Called when the node enters the scene tree for the first time.
func _ready():
	var _connectToDie = connect("died", self, "on_died")
	
	for child in get_children():
		if (child is DemonHurtbox):
			var _connectToChildResult = (child as DemonHurtbox).connect("struck", self, "on_hurtbox_struck", [ child ])


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
