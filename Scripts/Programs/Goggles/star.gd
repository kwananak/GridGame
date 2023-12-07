extends "res://Scripts/Programs/program.gd"

func _ready():
	info = "Action: ****"
	active = true
	super._ready()

func action():
	print(info)
