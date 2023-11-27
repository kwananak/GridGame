extends "res://Scripts/Programs/program.gd"

func _ready():
	info = "Passive : Can attack 2 blocks away"

func loaded():
	super.loaded()
	print(info)
