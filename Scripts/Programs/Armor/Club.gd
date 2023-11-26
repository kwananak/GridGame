extends "res://Scripts/Programs/program.gd"

func loaded():
	super.loaded()
	virtual_level_manager.is_immune_to_bullets = true
