extends "res://Scripts/Programs/program.gd"

func _ready():
	info = "Passive : Can see information about movements and distance of wall"
	super._ready()

func loaded():
	super.loaded()
	level_manager.vision = true
