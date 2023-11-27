extends "res://Scripts/Programs/program.gd"

func _ready():
	super._ready()

func loaded():
	info = "Passive : Make the wall of Doom slower for 1"
	super.loaded()
	print(info)
