extends Node2D

func add_to_programs(slot, program):
	for n in get_node("OwnedPrograms/" + slot).get_children():
		if n.name == program.name:
			return
	if get_node("Loadout/" + slot).get_child_count() == 1:
		if get_node("Loadout/" + slot).get_child(0).name == program.name:
			return
	get_node("OwnedPrograms/" + slot).add_child(program)


func select_loadout(slot, program):
	var selected_slot = get_node("Loadout/" + slot)
	if selected_slot.get_child_count() == 1:
		var prog = selected_slot.get_child(0)
		selected_slot.remove_child(prog)
		get_node("OwnedPrograms/" + slot).add_child(prog)
	if program.name == "Empty":
		pass
	else:
		selected_slot.add_child(program)

func get_available_programs(slot):
	match slot:
		"LeftHand":
			pass
		"RightHand":
			pass
		_:
			var available_programs =[]
			var progs = get_node("OwnedPrograms/" + slot).get_children()
			for n in progs:
				available_programs += [n]
			var loaded_slot = get_node("Loadout/" + slot).get_children()
			if !loaded_slot.is_empty():
				for i in available_programs.size():
					print(available_programs[i])
					if available_programs[i].name == loaded_slot[0].name:
						available_programs += [i]
				loaded_slot[0].queue_free()
			for n in available_programs:
				if n is int:
					continue
				else:
					n.get_parent().remove_child(n)
			return available_programs

func reset_programs():
	for n in $Loadout.get_children():
		if !n.get_child_count() == 1:
			n.get_child(0).queue_free()
	for n in $OwnedPrograms.get_children():
		if !n.get_child_count() == 1:
			n.get_child(0).queue_free()
