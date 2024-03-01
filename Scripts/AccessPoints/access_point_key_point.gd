extends Area2D

var access_point

func _ready():
	access_point = get_tree().get_first_node_in_group("AccessPoint")

func _on_area_entered(_area):
	if access_point ==  null:
		return
	access_point.vulnerable = true
	for n in get_tree().get_nodes_in_group("AccessPointKeyPoint"):
		n.get_node("AnimatedSprite2D").frame = 1

func _on_area_exited(_area):
	for n in get_tree().get_nodes_in_group("AccessPointKeyPoint"):
		if n.has_overlapping_areas():
			return
	for n in get_tree().get_nodes_in_group("AccessPointKeyPoint"):
		n.get_node("AnimatedSprite2D").frame = 0
	if access_point != null:
		access_point.vulnerable = false
