extends "res://Scripts/Programs/program.gd"

@export var bit_number : int
@export var strength : int
@export var amplifier_class : String

func _ready():
	type = "NeuroEnhanceAmplifier" + amplifier_class
	info = "+" + str(strength) + " action"
	if strength > 1:
		info += "s"
	info += " from now on"
	super._ready()
