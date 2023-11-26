extends "res://Scripts/Programs/program.gd"

func loaded():
	super.loaded()
	virtual_level_manager.initial_health += 2
	virtual_level_manager.health += 2
