extends "res://Scripts/Programs/program.gd"

func _ready():
	info = "Action : Make all the bullets slower by 1 turn"
	active = true
	super._ready()

func action():
	for n in get_tree().get_nodes_in_group("Bullet"):
		n.speed -= 1
