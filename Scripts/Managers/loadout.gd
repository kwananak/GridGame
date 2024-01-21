extends Control

var selection_opened = null
var available_programs
var array_selected
var loaded_slots = 0
var max_loads = 3
var rune_mode = null

var progress_manager
var info
var prog_load

@onready var empty = preload("res://Scenes/Programs/Empty.tscn")

func _ready():
	progress_manager = get_tree().get_first_node_in_group("ProgressManager")
	prog_load = progress_manager.get_node("Loadout")
	info = get_parent().get_node("Info/Label")
	await get_tree().create_timer(0.02).timeout
	set_slots()

func set_slots():
	loaded_slots = 0
	prog_load.show()
	for n in get_children():
		match n.name:
			"Label":
				continue
			"Runes":
				var v = prog_load.get_node(str(n.name))
				v.global_position = n.global_position + Vector2(16, 16)
			_:
				var v = prog_load.get_node(str(n.name))
				v.global_position = n.global_position + Vector2(16, 16)
				if v.get_child_count() > 0:
					loaded_slots += 1
	$Label.text = "available loads: " + str(max_loads - loaded_slots)

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

func on_button_pressed(slot):
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
			info.text = "nothing to runed"
			return
	if selection_opened:
		if selection_opened == slot:
			confirm_loadout(slot)
		return
	if loaded_slots >= max_loads && progress_manager.get_node("Loadout/" + slot).get_child_count() == 0:
		info.text = "max program quantity reach"
		return
	open_program_selection(slot)

func confirm_loadout(slot):
	var selected_program = available_programs[array_selected].duplicate(15)
	selected_program.position = Vector2.ZERO
	selected_program.scale = Vector2(1, 1)
	progress_manager.select_loadout(slot, selected_program)
	for n in available_programs:
		n.monitorable = false
		remove_child(n)
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
	set_slots()
	get_tree().get_first_node_in_group("MouseToolTip").hide()
	get_node(slot).grab_focus()
	_on_focus_entered(slot)

func open_program_selection(slot):
	get_node(slot).release_focus()
	info.text = ""
	array_selected = 0
	selection_opened = slot
	var new_empty = empty.instantiate()
	available_programs = [new_empty] + progress_manager.get_available_programs(slot)
	for n in available_programs:
		if n is int:
			array_selected = n + 1
			available_programs.erase(n) 
		else:
			add_child(n)
			n.position = get_node(slot).position + Vector2(32, 32)
			n.scale = Vector2(1.5, 1.5)
	set_program_sprites()

func set_program_sprites():
	for i in available_programs.size():
		if i == array_selected:
			available_programs[i].z_index = 2
			var tween = create_tween()
			tween.tween_property(available_programs[i], "scale",
				Vector2(2, 2),
				0.3).set_trans(Tween.TRANS_SINE)
		else:
			available_programs[i].z_index = 1
			var tween = create_tween()
			tween.tween_property(available_programs[i], "scale",
				Vector2(1.5, 1.5),
				0.3).set_trans(Tween.TRANS_SINE)
		var tween = create_tween()
		tween.tween_property(available_programs[i], "position",
				get_node(selection_opened).position + Vector2(((i - array_selected) * 64) + 32, 32),
				0.3).set_trans(Tween.TRANS_SINE)
		available_programs[i].show()
	info.text = available_programs[array_selected].name + "\n" + available_programs[array_selected].info

func _on_focus_entered(slot):
	if slot == "Runes":
		var rune_count = progress_manager.get_node("Loadout/" + slot).get_child_count()
		match rune_count:
			0:
				info.text = "no rune"
			1:
				info.text = "1 rune"
			_:
				info.text = str(rune_count) + " runes"
		return
	if progress_manager.get_node("Loadout/" + slot).get_child_count() == 1:
		info.text = slot + "\n" + progress_manager.get_node("Loadout/" + slot).get_child(0).name + "\n" + progress_manager.get_node("Loadout/" + slot).get_child(0).info
	else:
		info.text = slot + "\n" + "Empty"

func _on_focus_exited():
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
		info.text = "no runes"
