extends Panel

onready var y_invert_toggle: CheckButton = $VBoxContainer/YInvert

func on_y_invert_toggled(pressed: bool):
	var player_settings = get_node("/root/PlayerSettings")
	player_settings.set_y_invert(pressed)

func _ready():
	var _on_connect_y_invert y_invert_toggle.connect("toggled", self, "on_y_invert_toggled")

