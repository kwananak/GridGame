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
			await get_tree().create_timer(0.1).timeout
			for n in get_tree().get_nodes_in_group("EndTile"):
				if n.global_position == global_position:
					if get_tree().get_first_node_in_group("RealPlayer").global_position == global_position:
						continue
					n.on = true
