extends Node2D

# called by level manager at end of level to add picked up programs
func add_to_programs(slot, program):
	if program.name == "Rune":
		get_node("Loadout/Runes").call_deferred("add_child", program)
		return
	for n in get_node("OwnedPrograms/" + slot).get_children():
		if n.name == program.name:
			return
	get_node("OwnedPrograms/" + slot).call_deferred("add_child", program)

# adds selected program from terminal to loadout
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

# called by terminal to get available programs for selected slot
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
				if loaded_slot[0].runed:
					var rune = loaded_slot[0].get_node("Rune")
					loaded_slot[0].remove_child(rune)
					$Loadout/Runes.add_child(rune)
					rune.position = Vector2.ZERO
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
				if loaded_slot[0].runed:
					var rune = loaded_slot[0].get_node("Rune")
					loaded_slot[0].remove_child(rune)
					$Loadout/Runes.add_child(rune)
					rune.position = Vector2.ZERO
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
				if loaded_slot[0].runed:
					var rune = loaded_slot[0].get_node("Rune")
					loaded_slot[0].remove_child(rune)
					$Loadout/Runes.add_child(rune)
					rune.position = Vector2.ZERO
				loaded_slot[0].queue_free()
	for n in available_programs:
		if n is int:
			continue
		else:
			n.get_parent().remove_child(n)
	return available_programs

# erases all program when called by main menu button
# for debugging pruposes
func reset_programs():
	for n in get_children():
		for o in n.get_children():
			if o.get_child_count() > 0:
				for p in o.get_children():
					p.queue_free()

func save():
	var dict = {}
	for n in get_children():
		dict[n.name] = {}
		for o in n.get_children():
			var slot = get_node(str(n.name) + "/" + str(o.name))
			if slot.get_child_count() > 0:
				dict[n.name][o.name] = []
				for p in slot.get_children():
					if p.get("runed"):
						if p.runed:
							dict[n.name][o.name] += [p.name + "_runed"]
							continue
					else:
						dict[n.name][o.name] += [p.name]
			else:
				dict[n.name][o.name] = ["empty"]
	return dict

func save_game():
	var save_file = FileAccess.open("res://savegame.txt", FileAccess.WRITE)
	save_file.store_line(JSON.stringify(save()))

func load_game():
	await reset_programs()
	if not FileAccess.file_exists("res://savegame.txt"):
		return
	var save_file = FileAccess.open("res://savegame.txt", FileAccess.READ)
	var json_string = save_file.get_line()
	var json = JSON.new()
	var parse_result = json.parse(json_string)
	if not parse_result == OK:
		print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
		return
	var data = json.get_data()
	for n in data.keys():
		for o in data[n]:
			if o == "Runes":
				for i in data[n][o].size():
					get_node(n).get_node(o).add_child(load("res://Scenes/Programs/Runes/Rune.tscn").instantiate())
				continue
			for p in data[n][o]:
				if p != "empty":
					if p.ends_with("runed"):
						var s = p.get_slice("_", 0)
						var v = load("res://Scenes/Programs/" + o + "/" + s + ".tscn").instantiate()
						get_node(n).get_node(o).add_child(v)
						v.add_child(load("res://Scenes/Programs/Runes/Rune.tscn").instantiate())
						v.runed = true
					else:
						if o == "LeftHand" || o == "RightHand":
							get_node(n).get_node(o).add_child(load("res://Scenes/Programs/Hands/" + p + ".tscn").instantiate())
							continue
						get_node(n).get_node(o).add_child(load("res://Scenes/Programs/" + o + "/" + p + ".tscn").instantiate())
