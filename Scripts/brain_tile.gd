extends "res://Scripts/program_tile.gd"

@export_enum("SynthetikThought", "CyberPulseCognitive", "CyberCogniMesh", "NeuroSync Cortex") var select_program : String

func _ready():
	program_type = select_program
	program_slot = "Brain"
	super._ready()
