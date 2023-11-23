extends "res://Scripts/level_manager.gd"

# called by player when activating a terminal
func call_terminal():
	terminal_is_opened = true
	$/root/Main.call_terminal_scene(get_parent())
