extends "res://Scripts/Programs/program.gd"

func _ready():
	info = "Action : Destroy everything around the player"
	active = true
	super._ready()

func action():
	player.circle_hit()
