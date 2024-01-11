extends "res://Scripts/Programs/program.gd"

func _ready():
	info = "Passive : Gives you 1 shield and regen every 6 turns"
	super._ready()

func loaded():
	super.loaded()
	await get_tree().create_timer(0.2).timeout
	level_manager.shields += 1
