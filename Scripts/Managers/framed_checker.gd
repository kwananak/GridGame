extends Node2D

var camera

func _ready():
	camera = get_tree().get_first_node_in_group("Camera")

func check(pos):
	if pos.x < camera.position.x - get_viewport_rect().size.x / 4:
		return false
	return true
