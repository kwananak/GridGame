extends "res://Scripts/Programs/program.gd"

func _ready():
	info = "Action : ?Grapping of 5?"
	active = true
	super._ready()

func action():
	print(info)
