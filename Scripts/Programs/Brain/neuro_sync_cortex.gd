extends "res://Scripts/Programs/program.gd"

func _ready():
	info = "Passive : +4 Action"

func loaded():
	super.loaded()
	virtual_level_manager.remaining_actions += 4
