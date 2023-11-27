extends "res://Scripts/Programs/program.gd"

func _ready():
	info = "Action : Destroy 3 blocks in front of you"
	super._ready()
	usable = true

func action():
	print(info)
	usable = false
