extends Area2D

@export var door_number : int

func _on_area_entered(_area):
	if get_tree().get_first_node_in_group("VirtualLevelManager") != null:
		get_tree().get_first_node_in_group("VirtualLevelManager").on_end_tile_entered()
	else:
		var l_m = get_tree().get_first_node_in_group("RealLevelManager")
		l_m.real_done = door_number
		l_m.on_end_tile_entered()
