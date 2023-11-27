extends "res://Scripts/Programs/program.gd"

func _ready():
	info = "not implemented active action"
	super._ready()
	usable = true

func action():
	print(info)
	usable = false

