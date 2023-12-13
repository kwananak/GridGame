extends Node2D

func add_to_programs(slot, program):
	for n in get_node("OwnedPrograms/" + slot).get_children():
		if n.name == program.name:
			return
	get_node("OwnedPrograms/" + slot).call_deferred("add_child", program)


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
	var available_programs =[]
	match slot:
		"LeftHand":
			var progs = get_node("OwnedPrograms/Hands").get_children()
			for n in progs:
				available_programs += [n]
			var loaded_slot_2 = get_node("Loadout/RightHand").get_children()
			if !loaded_slot_2.is_empty():
				for i in available_programs.size():
					if available_programs[i].name == loaded_slot_2[0].name:
						available_programs.remove_at(i)
						break
			var loaded_slot = get_node("Loadout/" + slot).get_children()
			if !loaded_slot.is_empty():
				for i in available_programs.size():
					if available_programs[i].name == loaded_slot[0].name:
						available_programs += [i]
				loaded_slot[0].queue_free()
		"RightHand":
			var progs = get_node("OwnedPrograms/Hands").get_children()
			for n in progs:
				available_programs += [n]
			var loaded_slot_2 = get_node("Loadout/LeftHand").get_children()
			if !loaded_slot_2.is_empty():
				for i in available_programs.size():
					if available_programs[i].name == loaded_slot_2[0].name:
						available_programs.remove_at(i)
						break
			var loaded_slot = get_node("Loadout/" + slot).get_children()
			if !loaded_slot.is_empty():
				for i in available_programs.size():
					if available_programs[i].name == loaded_slot[0].name:
						available_programs += [i]
				loaded_slot[0].queue_free()
		_:
			var progs = get_node("OwnedPrograms/" + slot).get_children()
			for n in progs:
				available_programs += [n]
			var loaded_slot = get_node("Loadout/" + slot).get_children()
			if !loaded_slot.is_empty():
				for i in available_programs.size():
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
		if n.get_child_count() == 1:
			n.get_child(0).queue_free()
	for n in $OwnedPrograms.get_children():
		if n.get_child_count() > 0:
			for o in n.get_children():
				o.queue_free()
