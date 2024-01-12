extends Area2D

@export_enum("Yellow", "Red") var type : String

func _on_area_entered(area):
	match type:
		"Yellow":
			if area.is_in_group("VirtualPlayer"):
				get_tree().get_first_node_in_group("FireWall").step = get_tree().get_first_node_in_group("VirtualLevelManager").yellow_firewall_step
				get_tree().get_first_node_in_group("WarningUI").frame = 1
			for n in get_tree().get_nodes_in_group("YellowWarning"):
				n.queue_free()
		"Red":
			if area.is_in_group("VirtualPlayer"):
				get_tree().get_first_node_in_group("FireWall").step = get_tree().get_first_node_in_group("VirtualLevelManager").red_firewall_step
				get_tree().get_first_node_in_group("WarningUI").frame = 2
			for n in get_tree().get_nodes_in_group("RedWarning"):
				n.queue_free()