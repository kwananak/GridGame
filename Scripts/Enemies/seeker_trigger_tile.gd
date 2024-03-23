extends Area2D

@export var seeker_number = 0

func _on_area_entered(_area):
	for n in get_tree().get_nodes_in_group("SeekerEnemies"):
		if n.seeker_number == seeker_number:
			n.activated = true
