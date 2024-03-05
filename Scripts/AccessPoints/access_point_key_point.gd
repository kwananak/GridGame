extends Area2D

var access_point
@export var access_point_number = 0

func _ready():
	if access_point_number == 0:
		access_point = get_tree().get_first_node_in_group("AccessPoint")
	else:
		for n in get_tree().get_nodes_in_group("AccessPoint"):
			if n.access_point_number == access_point_number:
				access_point = n

func _on_area_entered(_area):
	if access_point ==  null:
		return
	access_point.vulnerable = true
	for n in get_tree().get_nodes_in_group("AccessPointKeyPoint"):
		if n.access_point_number == access_point_number:
			n.get_node("AnimatedSprite2D").frame = 1

func _on_area_exited(_area):
	for n in get_tree().get_nodes_in_group("AccessPointKeyPoint"):
		if n.has_overlapping_areas():
			return
	for n in get_tree().get_nodes_in_group("AccessPointKeyPoint"):
		if n.access_point_number == access_point_number:
			n.get_node("AnimatedSprite2D").frame = 0
	if access_point != null:
		access_point.vulnerable = false
