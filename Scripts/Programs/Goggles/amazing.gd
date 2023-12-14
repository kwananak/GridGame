extends "res://Scripts/Programs/program.gd"

var firewall
var distance = -5

func _ready():
	info = "Action : Make the wall go back 5 squares"
	super._ready()
	firewall = get_tree().get_first_node_in_group("FireWall")

func loaded():
	active = true
	super.loaded()

func action():
	player.moving = true
	firewall.skip_turn = true
	player.skip_turn()
	firewall.move_wall(distance)
