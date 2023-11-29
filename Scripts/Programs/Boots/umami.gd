extends "res://Scripts/Programs/program.gd"

func _ready():
	info = "Passive : Makes the wall of Doom slower by 1"
	super._ready()

func loaded():
	super.loaded()
	level_manager.firewall_speed -= 1
