extends "res://Scripts/Programs/program.gd"

func _ready():
	info = "Passive : Makes the wall of Doom slower for 1"
	super._ready()

func loaded():
	super.loaded()
	print(info)
