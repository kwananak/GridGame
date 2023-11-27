extends "res://Scripts/Programs/program.gd"

func _ready():
	info = "Passive : All blocks are down 1 strength"

func loaded():
	super.loaded()
	print(info)
