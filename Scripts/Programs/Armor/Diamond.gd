extends "res://Scripts/Programs/program.gd"

func loaded():
	super.loaded()
	virtual_level_manager.lives += 1
