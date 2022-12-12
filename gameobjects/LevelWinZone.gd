class_name LevelWinZone extends Area

signal player_entered_win_zone()

func on_player_entered(_node):
	emit_signal("player_entered_win_zone")
	
	get_tree().call_group("listen_for_stage_complete", "player_finished_stage")

func _ready():
	var _connect_to_player_entered = connect("body_entered", self, "on_player_entered")
