extends "res://Scripts/Programs/program_tile.gd"

@export_enum("Heart", "Silicone", "Club", "Spade", "Joker") var select_program : String

func _ready():
	program_type = select_program
	program_slot = "Armor"
	super._ready()
