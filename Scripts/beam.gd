extends Area2D

func _on_area_entered(area):
	if area.is_in_group("Player"):
		get_tree().get_first_node_in_group("VirtualLevelManager").call_game_over()
