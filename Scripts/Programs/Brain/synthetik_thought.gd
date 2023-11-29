extends "res://Scripts/Programs/program.gd"

func _ready():
	info = "Passive : +1 Action"

func loaded():
	super.loaded()
	level_manager.remaining_actions += 1
