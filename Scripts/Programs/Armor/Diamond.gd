extends "res://Scripts/Programs/program.gd"

func _ready():
	info = "Passive : Gives you 1 extra life and regen every 6 turns"
	super._ready()

func loaded():
	super.loaded()
	virtual_level_manager.lives += 1
