extends "res://Scripts/Programs/program.gd"

func _ready():
	info = "Action : Make all the bullet slower by 1 turn"
	super._ready()
	usable = true

func action():
	print(info)
	usable = false
