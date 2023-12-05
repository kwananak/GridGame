extends "res://Scripts/Programs/program.gd"

func _ready():
	info = "Passive : +4 Actions"
	super._ready()

func loaded():
	super.loaded()
	level_manager.remaining_actions += 4
