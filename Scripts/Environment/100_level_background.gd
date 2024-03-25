extends "res://Scripts/Environment/virtual_level_background.gd"

var textures = []
var frame = 0
var frame_counter = 0.0

func _ready():
	super._ready()
	for i in 7:
		var wall = get_tree().get_first_node_in_group("100Walls" + str(i))
		if wall:
			textures += [get_tree().get_first_node_in_group("100Walls" + str(i)).texture]

func _process(delta):
	super._process(delta)
	frame_counter += delta
	if frame_counter > 0.3:
		for n in textures:
			if int(frame) % 10 == 0:
				n.region.position.x = int(n.region.position.x) % 96
			else:
				n.region.position.x = n.region.position.x + 96
		frame += 1
		frame_counter = 0
