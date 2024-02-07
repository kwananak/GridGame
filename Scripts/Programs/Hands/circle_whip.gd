extends "res://Scripts/Programs/program.gd"

@export var strength = 3

func _ready():
	info = "Action : Destroy everything around the player"
	super._ready()

func loaded():
	active = true
	super.loaded()

func action():
	player.circle_hit(self)
