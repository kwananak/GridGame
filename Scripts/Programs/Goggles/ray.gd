extends "res://Scripts/Programs/program.gd"

func _ready():
	info = "Action : Can freeze all enemy for 5 turns"
	super._ready()
	usable = true

func action():
	print(info)
	usable = false
