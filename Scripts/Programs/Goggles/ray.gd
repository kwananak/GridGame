extends "res://Scripts/Programs/program.gd"

func _ready():
	info = "Action : Freeze all enemies for 5 turns"
	active = true
	super._ready()

func action():
	print(info)
