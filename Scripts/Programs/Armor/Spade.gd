extends "res://Scripts/Programs/program.gd"

func _ready():
	info = "Action : ****"
	super._ready()
	usable = true

func action():
	print(info)
	usable = false
