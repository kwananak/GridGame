extends Node2D

var camera

func _ready():
	camera = get_tree().get_first_node_in_group("Camera")


func _process(_delta):
	position.y = camera.position.y - 140 - camera.position.y / 2
