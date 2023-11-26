extends Node2D

var loadout = {"Brain" : "empty",
		"Goggles" : "empty",
		"Armor" : "empty",
		"LeftHand" : "empty",
		"RightHand" : "empty",
		"Boots" : "empty"}
var owned_programs = {"Brain" : [],
		"Goggles" : [],
		"Armor" : [],
		"Hands" : [],
		"Boots" : []}

func add_to_programs(slot, program):
	if slot == "Armor":
		$OwnedPrograms/Armor.add_child(load("res://Scenes/Programs/" + slot + "/" + program + ".tscn").instantiate())
	else:
		if !owned_programs[slot].has(program):
			owned_programs[slot] += [program]

func select_loadout(slot, program):
	if slot == "Armor":
		var armor_slot = $Loadout/Armor
		if armor_slot.get_children().size() > 0:
			var armor = armor_slot.get_children()[0]
			armor_slot.remove_child(armor)
			$OwnedPrograms/Armor.add_child(armor)
		if program == "empty":
			pass
		else:
			print($OwnedPrograms/Armor.get_children())
			print(program)
			var armor = $OwnedPrograms/Armor.find_child(program, false, false)
			print(armor)
			$OwnedPrograms/Armor.remove_child(armor)
			armor_slot.add_child(armor)
	else:
		loadout[slot] = program

func get_available_programs(slot):
	match slot:
		"Armor":
			var available_programs =[]
			var progs = $OwnedPrograms/Armor.get_children()
			for n in progs:
				available_programs += [n.name]
			return available_programs
		"LeftHand":
			var available_programs = owned_programs["Hands"].duplicate(true)
			if loadout["RightHand"] != "empty":
				available_programs.erase(loadout["RightHand"])
			return available_programs
		"RightHand":
			var available_programs = owned_programs["Hands"].duplicate(true)
			if loadout["LeftHand"] != "empty":
				available_programs.erase(loadout["LeftHand"])
			return available_programs
		_:
			return owned_programs[slot].duplicate(true)

func reset_programs():
	for n in owned_programs:
		owned_programs[n] = []
	for n in loadout:
		loadout[n] = "empty"
	for n in $Loadout.get_children():
		if !n.get_children().is_empty():
			n.get_children()[0].queue_free()
