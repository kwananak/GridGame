extends "res://Scripts/Programs/program.gd"

func _ready():
	info = "Passive : All blocks are down 1 strength"
	super._ready()

func loaded():
	super.loaded()
	for n in get_tree().get_nodes_in_group("Hittable"):
		if "strength" in n:
			if n.strength > 1:
				n.strength -= 1
