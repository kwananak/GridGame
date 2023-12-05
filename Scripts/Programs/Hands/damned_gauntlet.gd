extends "res://Scripts/Programs/program.gd"

func _ready():
	info = "Passive : All blocks are down 1 strength"
	super._ready()

func loaded():
	super.loaded()
	print(info)
