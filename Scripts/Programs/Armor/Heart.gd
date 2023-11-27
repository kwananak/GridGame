extends "res://Scripts/Programs/program.gd"

func _ready():
	info = "Passive : Gives you 2 extra health"
	super._ready()

func loaded():
	super.loaded()
	virtual_level_manager.initial_health += 2
	virtual_level_manager.health += 2
