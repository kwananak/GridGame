extends "res://Scripts/Programs/program.gd"

@export var strength = 1
@export var regen = 4

var regen_turn = 0
var used = 0 : set = set_used

func _ready():
	type = "Diamond"
	info = "Passive : Gives you " + str(strength) + " shield"
	if strength > 1:
		info += "s"
	else:
		info = "Passive : Gives you a shield"
	info += " and regen after " + str(regen) + " turns"
	super._ready()

func loaded():
	super.loaded()
	await get_tree().create_timer(0.2).timeout
	level_manager.shields += strength
	add_to_group("DiamondArmor")
	add_to_group("EndTurn")

func turn_call():
	if !is_in_group("DiamondArmor") || used == 0:
		$Label.text = ""
		return
	regen_turn += 1
	$Label.text = str(regen - regen_turn)
	if regen_turn == regen:
		regen_turn = 0
		level_manager.shields += 1
		used -= 1
		if used == 0:
			$Label.text = ""
		else:
			$Label.text = str(regen - regen_turn)

func set_used(value):
	if value < used:
		regen_turn = 0
	used = value
	if used == 0:
		$Label.text = ""
	if regen_turn < regen:
		$Label.text = str(regen - regen_turn)
