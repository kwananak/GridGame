extends "res://Scripts/Programs/program.gd"

func _ready():
	info = "Passive : Gives you 2 extra health"
	super._ready()

func loaded():
	super.loaded()
	level_manager.initial_health += 2
	level_manager.health += 2
