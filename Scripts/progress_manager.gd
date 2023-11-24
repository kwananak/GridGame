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
	owned_programs[slot] += [program]

func select_loadout(slot, program):
	loadout[slot] = program

func get_available_programs(slot):
	match slot:
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
