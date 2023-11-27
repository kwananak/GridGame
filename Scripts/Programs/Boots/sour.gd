extends "res://Scripts/Programs/program.gd"

func _ready():
	info = "Action : Teleport 2 in front"
	super._ready()
	usable = true

func action():
	print(info)
	usable = false
