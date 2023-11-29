extends "res://Scripts/program_tile.gd"

@export_enum("Vision", "Amazing", "Ray", "Ice", "Star") var select_program : String

func _ready():
	program_type = select_program
	program_slot = "Goggles"
	super._ready()

func _on_area_entered(_area):
	super.pick_up()
