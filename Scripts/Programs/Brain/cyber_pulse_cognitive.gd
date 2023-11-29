extends "res://Scripts/Programs/program.gd"

func _ready():
	info = "Passive : +2 Actions"

func loaded():
	super.loaded()
	level_manager.remaining_actions += 2
