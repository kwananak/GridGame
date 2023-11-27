extends "res://Scripts/Programs/program.gd"

func _ready():
	info = "Action : Shoot 1 bullet in front"
	super._ready()
	usable = true

func action():
	print(info)
	usable = false
