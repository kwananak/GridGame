extends "res://Scripts/Programs/program.gd"

func _ready():
	info = "Action : Can teleport 2 in front"
	super._ready()
	usable = true

func action():
	print(info)
	usable = false
