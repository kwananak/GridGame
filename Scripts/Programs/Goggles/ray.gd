extends "res://Scripts/Programs/program.gd"

func _ready():
	info = "Action : Freeze all enemies for 5 turns"
	super._ready()
	usable = true

func action():
	print(info)
	usable = false
