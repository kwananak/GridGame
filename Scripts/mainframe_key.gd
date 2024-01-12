extends Area2D

func _on_area_entered(_area):
	get_tree().get_first_node_in_group("Mainframe").locked = false
	get_tree().get_first_node_in_group("MainframeKeyUI").show()
	queue_free()
