extends Panel

onready var y_invert_toggle: CheckButton = $VBoxContainer/YInvert


onready var x_sensitivty_set = $VBoxContainer/HorizSensitivity/HSlider
onready var y_sensitivty_set = $VBoxContainer/VerticalSensitivity/HSlider

func on_y_invert_toggled(pressed: bool):
	var player_settings = get_node("/root/PlayerSettings")
	player_settings.set_y_invert(pressed)
	
func on_x_sensitivty_changed(value: float):
	var player_settings = get_node("/root/PlayerSettings")
	player_settings.set_x_sensitivity(value)

func on_y_sensitivty_changed(value: float):
	var player_settings = get_node("/root/PlayerSettings")
	player_settings.set_y_sensitivity(value)


func _ready():
	var _on_connect_y_invert =  y_invert_toggle.connect("toggled", self, "on_y_invert_toggled")
	var _on_x_sensitivity_change = x_sensitivty_set.connect("value_changed", self, "on_x_sensitivty_changed")
	var _on_y_sensitivity_change = y_sensitivty_set.connect("value_changed", self, "on_y_sensitivty_changed")

