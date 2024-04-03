extends Node2D

var log_path = "res://Txts/dialogs.txt"
var levels_path = "res://Txts/levels_info.txt"
var save_path = "user://savegame.save"
var completed_levels = []
var unlocked_levels = ["101", "201", "301"]
var doors = []
var save_point
var dialogs
var log_progress = {}
var levels
var bad_save = false
var just_unlocked

@onready var amplifiers = $OwnedPrograms/Amplifiers

func _ready():
	create_dialogs_dict()
	create_levels_dict()

func create_levels_dict():
	levels = {}
	var levels_file = FileAccess.open(levels_path, FileAccess.READ)
	levels_file.get_line()
	while true:
		var line = levels_file.get_line()
		if line.is_empty():
			break
		line = line.split(" : ")
		levels[line[0]] = {}
		levels[line[0]]["name"] = line[1]
		levels[line[0]]["difficulty"] = line[2]
		for n in line[3].split(","):
			levels[line[0]][n] = false

func create_dialogs_dict():
	dialogs = {}
	var log_file = FileAccess.open(log_path, FileAccess.READ)
	var section
	var sub_section
	while true:
		var line = log_file.get_line()
		if line.is_empty():
			break
		if int(line) > 100:
			section = line
			dialogs[section] = {}
			continue
		if int(line.substr(0, 1)):
			sub_section = line
			dialogs[section][sub_section] = {"color" : null, "log" : null, "text" : []}
			continue
		if line.begins_with("color"):
			dialogs[section][sub_section]["color"] = line.split(":")[1]
		elif line.begins_with("log"):
			dialogs[section][sub_section]["log"] = line.split(":")[1]
		else:
			dialogs[section][sub_section]["text"] += [line]

# called by level manager at end of level to add picked up programs
func add_to_programs(slot, program, level):
	if program.name == "Rune":
		get_node("Loadout/Runes").add_child(program)
		return
	for n in get_node("OwnedPrograms/" + slot).get_children():
		if n.type == program.type:
			return
	program.position = Vector2.ZERO
	just_unlocked = program.type
	get_node("OwnedPrograms/" + slot).call_deferred("add_child", program)
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
	call_deferred("save_game")

func add_amplifier(amp):
	amplifiers.call_deferred("add_child", amp)
	save_point = $/root/Main.real_scene.name
	call_deferred("save_game")

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
	unlocked_levels = ["101", "201", "301", "401"]
	doors = []
	log_progress = {}
	create_levels_dict()
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
						dict[n.name][o.name] += [p.type]
			else:
				dict[n.name][o.name] = ["empty"]
	dict["levels"] = levels
	dict["completed_levels"] = completed_levels
	dict["unlocked_levels"] = unlocked_levels
	dict["doors"] = doors
	dict["save_point"] = save_point
	dict["log_progress"] = log_progress
	return dict

func save_game():
	var save_file = FileAccess.open(save_path, FileAccess.WRITE)
	var s = save()
	save_file.store_line(JSON.stringify(s))
	save_file.close()

func load_game(save_number):
	await reset_progress()
	var json_string
	if !save_number:
		if not FileAccess.file_exists(save_path):
			$/root/Main.disable_continue()
			return
		var save_file = FileAccess.open(save_path, FileAccess.READ)
		json_string = save_file.get_line()
		save_file.close()
	else:
		if not FileAccess.file_exists("res://Txts/fixed_saves.txt"):
			$/root/Main.disable_continue()
			return
		var save_file = FileAccess.open("res://Txts/fixed_saves.txt", FileAccess.READ)
		for i in save_number:
			json_string = save_file.get_line()
		save_file.close()
	var json = JSON.new()
	var parse_result = json.parse(json_string)
	if not parse_result == OK:
		print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
		bad_save = true
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
			"log_progress":
				log_progress = data[n]
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
								if p != "empty" && p != "":
									if p.ends_with("runed"):
										var s = p.get_slice("_", 0)
										var v = load("res://Scenes/Programs/" + o + "/" + s + ".tscn").instantiate()
										get_node(n).get_node(o).add_child(v)
										v.add_child(load("res://Scenes/Programs/Runes/Rune.tscn").instantiate())
										v.runed = true
									else:
										if o == "LeftHand" || o == "RightHand":
											if !ResourceLoader.exists("res://Scenes/Programs/Hands/" + p + ".tscn"):
												bad_save = true
												return
											get_node(n).get_node(o).add_child(load("res://Scenes/Programs/Hands/" + p + ".tscn").instantiate())
											continue
										if !ResourceLoader.exists("res://Scenes/Programs/" + o + "/" + p + ".tscn"):
											bad_save = true
											return
										get_node(n).get_node(o).add_child(load("res://Scenes/Programs/" + o + "/" + p + ".tscn").instantiate())
