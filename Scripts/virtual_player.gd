extends "res://Scripts/player.gd"

func _ready():
	level_manager = get_tree().get_first_node_in_group("VirtualLevelManager")
	enter_level_animation()
