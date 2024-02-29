extends "res://Scripts/Programs/program.gd"

@export var bit_number : int
@export var strength : int

func _ready():
	type = "NeuroEnhanceAmplifier1"
	info = "+" + str(strength) + " action"
	if strength > 1:
		info += "s"
	info += " from now on"
	super._ready()
