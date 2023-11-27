extends "res://Scripts/Programs/program.gd"

func _ready():
	info = "Action : ?Grapping of 5?"
	super._ready()
	usable = true

func action():
	print(info)
	usable = false
