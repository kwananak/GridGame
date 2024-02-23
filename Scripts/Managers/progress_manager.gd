extends Node2D

var save_path = "user://savegame.save"
var completed_levels = []
var unlocked_levels = ["101", "201"]
var doors = ["2"]
var save_point
var levels = {"100" : {"200" : false},
			"101" : {"102" : false},
			"102" : {"103" : false, "prog" : false},
			"103" : {"2" : false},
			"200" : {"300" : false},
			"201" : {"202" : false, "prog" : false},
			"202" : {"203" : false, "prog" : false},
			"203" : {"204" : false, "prog" : false},
			"204" : {"205" : false, "prog" : false},
			"205" : {"206" : false, "prog" : false}}

@onready var amplifiers = $OwnedPrograms/Amplifiers

# called by level manager at end of level to add picked up programs
func add_to_programs(slot, program, level):
	if program.name == "Rune":
		get_node("Loadout/Runes").add_child(program)
		return
	for n in get_node("OwnedPrograms/" + slot).get_children():
		if n.name == program.name:
			return
	program.position = Vector2.ZERO
	get_node("OwnedPrograms/" + slot).add_child(program)
	levels[str(level)]["prog"] = true

func auto_loader():
	for n in $Loadout.get_children():
		for o in n.get_children():
			o.queue_free()
	await get_tree().create_timer(0.1).timeout
	for n in $OwnedPrograms.get_children():
		match n.name:
			"Amplifiers":
				continue
			"Hands":
				for i in n.get_child_count():
					if i == 0:
						$Loadout.get_node("LeftHand").add_child(n.get_child(0).duplicate())
					if i == 1:
						$Loadout.get_node("RightHand").add_child(n.get_child(1).duplicate())
			_:
				if n.get_child_count() > 0:
					$Loadout.get_node(str(n.name)).add_child(n.get_child(0).duplicate())

# called by level manager through main at end of level to add unlocked level and create automatic save_point
func add_to_levels(level_unlocked, real_level, level_completed):
	save_point = real_level
	levels[str(level_completed)][str(level_unlocked)] = true
	if level_unlocked > 100:
		if level_unlocked not in unlocked_levels:
			unlocked_levels += [str(level_unlocked)]
	else:
		if level_unlocked not in doors:
			doors += [str(level_unlocked)]
	var completed = true
	for n in levels[str(level_completed)]:
		if !levels[str(level_completed)][n]:
			completed = false
	if completed && level_completed not in completed_levels:
		completed_levels += [str(level_completed)]
	save_game()

func add_amplifier(amp):
	amplifiers.call_deferred("add_child", amp)
	save_point = $/root/Main.real_scene.name
	await get_tree().create_timer(0.05).timeout
	save_game()

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

# erases game state
func reset_progress():
	for n in get_children():
		for o in n.get_children():
			if o.get_child_count() > 0:
				for p in o.get_children():
					p.queue_free()
	completed_levels = []
	unlocked_levels = ["101", "201"]
	doors = []
	for n in levels:
		for o in levels[n]:
			levels[n][o] = false
	save_point = null

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
	dict["levels"] = levels
	dict["completed_levels"] = completed_levels
	dict["unlocked_levels"] = unlocked_levels
	dict["doors"] = doors
	dict["save_point"] = save_point
	return dict

func save_game():
	var save_file = FileAccess.open(save_path, FileAccess.WRITE)
	save_file.store_line(JSON.stringify(save()))
	save_file.close()

func load_game():
	await reset_progress()
	if not FileAccess.file_exists(save_path):
		$/root/Main.disable_continue()
		return
	var save_file = FileAccess.open(save_path, FileAccess.READ)
	var json_string = save_file.get_line()
	save_file.close()
	var json = JSON.new()
	var parse_result = json.parse(json_string)
	if not parse_result == OK:
		print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
		return
	var data = json.get_data()
	for n in data.keys():
		match n:
			"completed_levels":
				completed_levels = data[n]
				continue
			"unlocked_levels":
				unlocked_levels = data[n]
				continue
			"levels":
				levels = data[n]
				continue
			"doors":
				doors = data[n]
				continue
			"save_point":
				save_point = data[n]
				continue
			_: 
				for o in data[n]:
					match o:
						"Runes":
							if data[n][o] == ["empty"]:
								continue
							for i in data[n][o].size():
								get_node(n).get_node(o).add_child(load("res://Scenes/Programs/Runes/Rune.tscn").instantiate())
						"Amplifiers":
							if data[n][o] == ["empty"]:
								continue
							for p in data[n][o]:
								get_node(n).get_node(o).add_child(load("res://Scenes/Programs/Amplifiers/" + p + ".tscn").instantiate())
						_:
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
