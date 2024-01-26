extends "res://Scripts/Managers/level_manager.gd"

var turn = 0

func _ready():
	player = get_tree().get_first_node_in_group("RealPlayer")
	super._ready()

func end_turn(_value):
	pass

# called by player when activating a terminal
func call_terminal(terminal_name):
	$/root/Main.call_terminal_scene(terminal_name)
