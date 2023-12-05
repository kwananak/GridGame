extends "res://Scripts/Programs/program.gd"

func _ready():
	info = "Passive : Can attack 2 blocks away"
	super._ready()

func loaded():
	super.loaded()
	print(info)
