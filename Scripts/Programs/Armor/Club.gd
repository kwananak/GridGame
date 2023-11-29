extends "res://Scripts/Programs/program.gd"

func _ready():
	info = "Passive : Immune to bullets"
	super._ready()

func loaded():
	super.loaded()
	level_manager.is_immune_to_bullets = true
