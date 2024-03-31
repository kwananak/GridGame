extends "res://Scripts/Programs/program_tile.gd"

@export_enum("Sweet", "Neutrino", "Bitter", "Umami", "Salty") var select_program : String

func _ready():
	program_type = select_program
	program_slot = "Boots"
	super._ready()
