extends "res://Scripts/Programs/program.gd"

func _ready():
	info = "Action : Jump 4 in front (obstacle block the jump)"
	super._ready()
	usable = true

func action():
	print(info)
	usable = false