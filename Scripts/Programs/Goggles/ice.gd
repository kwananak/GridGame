extends "res://Scripts/Programs/program.gd"

func _ready():
	info = "Action : Make all the bullets slower by 1 turn"
	active = true
	super._ready()

func action():
	print(info)
