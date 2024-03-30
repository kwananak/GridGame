extends Area2D

var tile_type = "key"

func _on_area_entered(_area):
	for n in get_tree().get_nodes_in_group("AccessPoint"):
		n.locked = false
	get_tree().get_first_node_in_group("AccessPointKeyUI").show()
	$Audio.play()
	hide()
	await $Audio.finished
	queue_free()
