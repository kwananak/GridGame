extends "res://Scripts/Programs/program_tile.gd"

@export_enum("Vision", "CyberReality", "Ray", "Ice", "Star") var select_program : String

func _ready():
	program_type = select_program
	program_slot = "Goggles"
	super._ready()
