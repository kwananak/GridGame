extends "res://Scripts/Cutscenes/cutscene.gd"

var camera
var panning_left = false
var panning_speed = 5

func _ready():
	camera = get_tree().get_first_node_in_group("Camera")
	camera.position = Vector2(50.0, 0.0)
	super._ready()

func _process(delta):
	if panning_left:
		camera.position.x -= delta * panning_speed
		if camera.position.x < 0:
			panning_left = false
	else:
		camera.position.x += delta * panning_speed
		if camera.position.x > 100:
			panning_left = true
