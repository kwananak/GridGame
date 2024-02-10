extends "res://Scripts/Programs/program_tile.gd"

@export_enum("LoopPants", "CyberPulseCognitive", "CyberCogniMesh", "NeuroSyncCortex") var select_program : String

func _ready():
	program_type = select_program
	program_slot = "Brain"
	super._ready()
