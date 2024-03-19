extends Node2D

var camera

func _ready():
	camera = get_tree().get_first_node_in_group("Camera")

func check(pos):
	if pos.x < camera.position.x - get_viewport_rect().size.x / 4:
		return false
	if pos.x > camera.position.x + get_viewport_rect().size.x / 4:
		return false
	if pos.y < camera.position.y - get_viewport_rect().size.y / 4:
		return false
	if pos.y > camera.position.y + get_viewport_rect().size.y / 4:
		return false
	return true

func keep_in_frame(pos):
	var return_vector = pos
	if pos.x < camera.position.x - get_viewport_rect().size.x / 4:
		return_vector.x = camera.position.x - get_viewport_rect().size.x / 4
	if pos.x > camera.position.x + get_viewport_rect().size.x / 4:
		return_vector.x = camera.position.x + get_viewport_rect().size.x / 4
	if pos.y < camera.position.y - get_viewport_rect().size.y / 4:
		return_vector.y = camera.position.y - get_viewport_rect().size.y / 4
	if pos.y > camera.position.y + get_viewport_rect().size.y / 4:
		return_vector.y = camera.position.y + get_viewport_rect().size.y / 4
	return return_vector
