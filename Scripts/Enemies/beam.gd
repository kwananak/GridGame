extends Area2D

var cannon

func _on_area_entered(area):
	if area.is_in_group("Player"):
		get_tree().get_first_node_in_group("VirtualLevelManager").health -= 1
		if cannon.name.begins_with("Forever"):
			cannon.charge = -1
