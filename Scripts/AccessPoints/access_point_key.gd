extends Area2D

func _on_area_entered(_area):
	get_tree().get_first_node_in_group("AccessPoint").locked = false
	get_tree().get_first_node_in_group("AccessPointKeyUI").show()
	queue_free()
