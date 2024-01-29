extends "res://Scripts/Programs/program.gd"

var doomwall
var distance = -5

func _ready():
	info = "Action : Make the wall go back 5 squares"
	super._ready()
	doomwall = get_tree().get_first_node_in_group("DoomWall")

func loaded():
	active = true
	super.loaded()

func action():
	player.moving = true
	doomwall.skip_turn = true
	player.skip_turn()
	doomwall.move_wall(distance)
