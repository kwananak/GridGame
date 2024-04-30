extends Control

var selection_opened = null
var available_programs
var array_selected
var loaded_slots = 0
var max_loads = 6
var rune_mode = null

var progress_manager
var info
var prog_load

@onready var empty = preload("res://Scenes/Programs/Empty.tscn")
@onready var frame = $Background/Frame

func _ready():
	progress_manager = get_tree().get_first_node_in_group("ProgressManager")
	#max_loads += progress_manager.get_node("OwnedPrograms/Amplifiers").get_child_count()
	prog_load = progress_manager.get_node("Loadout")
	info = get_tree().get_first_node_in_group("InfoPanel")
	await get_tree().create_timer(0.3).timeout
	set_slots()

# removed from use because of programs auto-loading. remove "legacy" to use again
func legacy_input(event):
	if event is InputEventMouseButton:
		if event.is_pressed() && event.button_index == 1:
			for n in get_children():
				if n.name == "Label":
					continue
				for i in n.get_child_count():
					if n.get_child(i).mouse_on:
						array_selected = i
						confirm_loadout(n.name)
						get_viewport().set_input_as_handled()
						return
			if selection_opened:
				on_button_pressed(selection_opened)

func set_slots():
	loaded_slots = 0
	prog_load.show()
	for n in get_children():
		match n.name:
			"Label", "Background":
				continue
			"Amplifiers":
				var action_points = 0
				for a in progress_manager.get_node("OwnedPrograms/Amplifiers").get_children():
					n.get_node(a.amplifier_class).show()
					action_points += a.strength
				$Label.text = "Energy Charges: " + str(action_points)
			"Runes":
				var v = prog_load.get_node(str(n.name))
				v.global_position = n.global_position + Vector2(16, 16)
			_:
				var v = prog_load.get_node(str(n.name))
				v.global_position = n.global_position + Vector2(37, 36)
				v.scale = Vector2(2, 2)
				if v.get_child_count() > 0:
					v.get_child(0).get_node("Sprite2D").show()
					v.get_child(0).get_node("TileSprite").hide()
					v.get_child(0).get_node("LoadedSprite").hide()
					loaded_slots += 1

func _unhandled_input(event):
	if selection_opened == null:
		return
	if event.is_action_pressed("select"):
		on_button_pressed(selection_opened)
	if event.is_action_pressed("left"):
		cycle_programs("left")
	elif event.is_action_pressed("right"):
		cycle_programs("right")

func cycle_programs(cycle):
	if available_programs.size() == 1:
		return
	if cycle == "right" && array_selected < available_programs.size() - 1:
		array_selected += 1
	elif cycle == "left" && array_selected > 0:
		array_selected -= 1
	set_program_sprites()

# removed from use because of programs auto-loading. remove if true loop to use again
func on_button_pressed(slot):
	if true:
		return
	if rune_mode:
		if prog_load.get_node(slot).get_child_count() > 0:
			var v = prog_load.get_node(slot).get_child(0)
			if !v.runed:
				prog_load.get_node("Runes").remove_child(rune_mode)
				v.add_child(rune_mode)
				v.runed = true
				rune_mode.position = Vector2(12, 12)
				rune_mode.name = "Rune"
				rune_mode = null
				return
			else:
				info.text = "already runed"
				return
		else:
			info.text = "nothing to rune"
			return
	if selection_opened:
		if selection_opened == slot:
			confirm_loadout(slot)
		return
	if loaded_slots >= max_loads && progress_manager.get_node("Loadout/" + slot).get_child_count() == 0:
		info.text = slot + "\nmax program quantity reach\nunequip a program to equip an other one"
		return
	open_program_selection(slot)

func confirm_loadout(slot):
	var selected_program = available_programs[array_selected].duplicate(15)
	selected_program.z_index = 0
	selected_program.position = Vector2.ZERO
	selected_program.scale = Vector2(1, 1)
	progress_manager.select_loadout(slot, selected_program)
	for n in available_programs:
		n.monitorable = false
		get_node(str(slot)).remove_child(n)
		if n.name == "Empty":
			n.queue_free()
		else:
			match slot:
				"LeftHand", "RightHand":
					progress_manager.get_node("OwnedPrograms/Hands").add_child(n)
					n.position = Vector2.ZERO
				_:
					progress_manager.get_node("OwnedPrograms/" + slot).add_child(n)
					n.position = Vector2.ZERO
	selection_opened = null
	available_programs = null
	for n in get_children():
		if n.name == "Label":
			continue
		n.focus_mode = Control.FOCUS_ALL
	set_slots()
	get_tree().get_first_node_in_group("MouseToolTip").hide()
	get_node(str(slot)).grab_focus()
	_on_focus_entered(slot)

func open_program_selection(slot):
	get_node(slot).release_focus()
	frame.visible = true
	info.text = ""
	array_selected = 0
	selection_opened = slot
	for n in get_children():
		if n.name == "Label":
			continue
		n.focus_mode = Control.FOCUS_NONE
	var new_empty = empty.instantiate()
	available_programs = [new_empty] + progress_manager.get_available_programs(slot)
	for n in available_programs:
		if n is int:
			array_selected = n + 1
			available_programs.erase(n) 
		else:
			get_node(slot).add_child(n)
			n.global_position = get_node(slot).global_position + Vector2(22, 22)
			n.scale = Vector2(1.3, 1.3)
	set_program_sprites()

func set_program_sprites():
	for i in available_programs.size():
		if i == array_selected:
			available_programs[i].z_index = 92
			var tween = create_tween()
			tween.tween_property(available_programs[i], "scale",
				Vector2(3, 3),
				0.3).set_trans(Tween.TRANS_SINE)
		else:
			available_programs[i].z_index = 91
			var tween = create_tween()
			tween.tween_property(available_programs[i], "scale",
				Vector2(2, 2),
				0.3).set_trans(Tween.TRANS_SINE)
		var tween = create_tween()
		tween.tween_property(available_programs[i], "global_position",
				get_node(selection_opened).global_position + Vector2(((i - array_selected) * 48) + 22, 22),
				0.3).set_trans(Tween.TRANS_SINE)
		available_programs[i].show()
	info.text = selection_opened + "\n" + available_programs[array_selected].name + "\n" + available_programs[array_selected].info

func _on_focus_entered(slot):
	frame.visible = true
	var focus = get_node(slot + "/Focus")
	match slot:
		"Runes":
			var rune_count = progress_manager.get_node("Loadout/" + slot).get_child_count()
			match rune_count:
				0:
					info.text = "no rune"
				1:
					info.text = "1 rune"
				_:
					info.text = str(rune_count) + " runes"
			return
		"Amplifiers":
			info.text = "NeuroAmplifers\n"
			var has_amplifier = false
			for n in $Amplifiers.get_children():
				if n.name.length() < 2:
					if n.visible:
						info.text += n.name + " "
						has_amplifier = true
			if !has_amplifier:
				info.text += "none"
			info.text += "\n" + $Label.text
		_:
			if progress_manager.get_node("Loadout/" + slot).get_child_count() == 1:
				info.text = string_with_spaces(slot) + "\n" + progress_manager.get_node("Loadout/" + slot).get_child(0).type_as_string() + "\n" + progress_manager.get_node("Loadout/" + slot).get_child(0).info
				focus.get_node("AnimationPlayer").play("full")
			else:
				info.text = string_with_spaces(slot) + "\n" + "Empty"
				focus.get_node("AnimationPlayer").play("empty")
	focus.show()

func string_with_spaces(unspaced):
	var spaced_string = ""
	for i in unspaced.length():
		var character = unspaced.substr(i, 1)
		if character == character.to_upper() && i > 0:
			spaced_string += " "
		spaced_string += character
	return spaced_string

func _on_focus_exited():
	for n in get_children():
		if n.has_node("Focus"):
			n.get_node("Focus").hide()
	frame.visible = false
	info.text = ""

func _on_rune_pressed():
	if selection_opened:
		return
	if rune_mode:
		rune_mode.position = Vector2.ZERO
		rune_mode = null
		return
	if prog_load.get_node("Runes").get_child_count() > 0:
		rune_mode = prog_load.get_node("Runes").get_child(0)
		rune_mode.position = Vector2(30, -100)
	else:
		info.text = "NO RUNE"

func _on_mouse_entered(slot):
	if selection_opened:
		return
	get_node(slot).grab_focus()
