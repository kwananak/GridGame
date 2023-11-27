extends "res://Scripts/Programs/program.gd"

func _ready():
	super._ready()

func loaded():
	info = "Passive : Can see information about mouvement and distance of wall"
	super.loaded()
	print(info)
