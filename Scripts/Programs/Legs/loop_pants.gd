extends "res://Scripts/Programs/program.gd"

func _ready():
	type = "LoopPants"
	info = "Passive : +1 Action"
	super._ready()

func loaded():
	super.loaded()
	level_manager.remaining_actions += 1
