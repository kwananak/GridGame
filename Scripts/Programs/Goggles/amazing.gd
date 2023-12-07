extends "res://Scripts/Programs/program.gd"

func _ready():
	info = "Action : Make the wall go back 5 squares"
	active = true
	super._ready()

func action():
	print(info)
