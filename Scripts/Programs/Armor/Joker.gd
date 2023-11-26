extends "res://Scripts/Programs/program.gd"

func _ready():
	super._ready()
	usable = true

func action():
	virtual_level_manager.invincible_for_turns = 3
	usable = false
