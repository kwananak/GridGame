extends Area2D

var tile_type = "hole"
var level_manager

func _ready():
	level_manager = get_tree().get_first_node_in_group("VirtualLevelManager")

func _on_area_entered(area):
	if level_manager.floating == false:
		level_manager.call_game_over()
