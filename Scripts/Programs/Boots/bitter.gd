extends "res://Scripts/Programs/program.gd"

func _ready():
	super._ready()

func loaded():
	info = "Passive : float"
	super.loaded()
	print(info)
