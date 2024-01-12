extends Area2D

func _on_area_entered(_area):
	get_tree().get_first_node_in_group("Mainframe").vulnerable = true
	for n in get_tree().get_nodes_in_group("MainframeKeypoint"):
		n.get_node("AnimatedSprite2D").frame = 1

func _on_area_exited(_area):
	for n in get_tree().get_nodes_in_group("MainframeKeypoint"):
		if n.has_overlapping_areas():
			return
	for n in get_tree().get_nodes_in_group("MainframeKeypoint"):
		n.get_node("AnimatedSprite2D").frame = 0
	get_tree().get_first_node_in_group("Mainframe").vulnerable = false
	
