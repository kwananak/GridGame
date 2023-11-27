extends "res://Scripts/Programs/program.gd"

func _ready():
	info = "Action : Make the wall go back 5 squares"
	super._ready()
	usable = true

func action():
	print(info)
	usable = false
