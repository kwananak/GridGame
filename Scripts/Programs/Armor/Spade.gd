extends "res://Scripts/Programs/program.gd"

func _ready():
	info = "Action : ****"
	super._ready()

func loaded():
	active = true
	super.loaded()

func action():
	print(info)
