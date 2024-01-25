extends "res://Scripts/Environment/door_tile.gd"

@export var door_number : int

var progress_manager

func _ready():
	level_manager = get_tree().get_first_node_in_group("RealLevelManager")
	progress_manager = get_tree().get_first_node_in_group("ProgressManager")
	update_door()

func update_door():
	for i in progress_manager.doors:
		if i == str(door_number):
			animated_sprite_2d.frame = 1
			unlocked = true
