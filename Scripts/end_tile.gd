extends Area2D

func _on_area_entered(_area):
	get_tree().get_first_node_in_group("LevelManager").on_end_tile_entered()
