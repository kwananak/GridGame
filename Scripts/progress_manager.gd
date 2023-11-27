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
	if slot == "Armor" || slot == "Brain" || slot == "Goggles" || slot == "Boots":
		for n in get_node("OwnedPrograms/" + slot).get_children():
			if n.name == program:
				return
		if get_node("Loadout/" + slot).get_child_count() == 1:
			if get_node("Loadout/" + slot).get_child(0).name == program:
				return
		get_node("OwnedPrograms/" + slot).add_child(load("res://Scenes/Programs/" + slot + "/" + program + ".tscn").instantiate())
	else:
		if !owned_programs[slot].has(program):
			owned_programs[slot] += [program]

func select_loadout(slot, program):
	if slot == "Armor" || slot == "Brain" || slot == "Goggles" || slot == "Boots":
		var selected_slot = get_node("Loadout/" + slot)
		if selected_slot.get_child_count() == 1:
			var prog = selected_slot.get_child(0)
			selected_slot.remove_child(prog)
			get_node("OwnedPrograms/" + slot).add_child(prog)
		if program == "empty":
			pass
		else:
			var sel = get_node("OwnedPrograms/" + slot).find_child(program, false, false)
			get_node("OwnedPrograms/" + slot).remove_child(sel)
			selected_slot.add_child(sel)
	else:
		loadout[slot] = program

func get_available_programs(slot):
	match slot:
		"Armor", "Brain", "Goggles", "Boots":
			var available_programs =[]
			var progs = get_node("OwnedPrograms/" + slot).get_children()
			for n in progs:
				available_programs += [n.name]
			var loaded_slot = get_node("Loadout/" + slot).get_children()
			if !loaded_slot.is_empty():
				available_programs += [loaded_slot[0].name]
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
		if !n.get_child_count() == 1:
			n.get_child(0).queue_free()
