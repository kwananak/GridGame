extends "res://Scripts/Programs/program_tile.gd"

@export_enum("DamnedGauntlet", "DestroyerGlove", "CircleWhip", "ChillingLance", "GrapplingTool", "1-0-1Shotgun") var select_program : String

func _ready():
	program_type = select_program
	program_slot = "Hands"
	super._ready()
