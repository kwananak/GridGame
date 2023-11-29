extends "res://Scripts/Programs/program.gd"

func _ready():
	info = "Passive : float bravo  bravo"
	super._ready()

func loaded():
	super.loaded()
	print(info)
