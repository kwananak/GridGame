extends "res://Scripts/program_tile.gd"

@export_enum("SynthetikThought", "CyberPulseCognitive", "CyberCogniMesh", "NeuroSyncCortex") var select_program : String

func _ready():
	program_type = select_program
	program_slot = "Brain"
	super._ready()

func _on_area_entered(_area):
	super.pick_up()
