extends "res://Scripts/Environment/door_tile.gd"

func _ready():
	level_manager = get_tree().get_first_node_in_group("RealLevelManager")

func update_door():
	animated_sprite_2d.frame = 1
	unlocked = true
