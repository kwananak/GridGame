extends Area2D

func _on_area_entered(_area):
	if get_tree().get_first_node_in_group("VirtualLevelManager") != null:
		get_tree().get_first_node_in_group("VirtualLevelManager").on_end_tile_entered()
	else:
		get_tree().get_first_node_in_group("RealLevelManager").on_end_tile_entered()
