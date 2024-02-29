extends "res://Scripts/Programs/program.gd"

@export var strength = 3

func _ready():
	type = "CircleWhip"
	info = "Action : Destroy enemies and Bytes Barrier around you"
	super._ready()

func loaded():
	active = true
	super.loaded()

func action():
	player.circle_hit(self)
