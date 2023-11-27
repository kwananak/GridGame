extends "res://Scripts/Programs/program.gd"

func _ready():
	info = "Action : Destroy everything around the player"
	super._ready()
	usable = true

func action():
	print(info)
	usable = false
