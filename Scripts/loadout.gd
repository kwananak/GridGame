extends ColorRect

var progress_manager
var selection_opened = null
var available_programs
var empty
var array_selected

func _ready():
	progress_manager = get_tree().get_first_node_in_group("ProgressManager")
	empty = preload("res://Scenes/Programs/Empty.tscn")
	set_slots()

func set_slots():
	progress_manager.get_node("Loadout").show()
	for n in get_children():
		progress_manager.get_node("Loadout/" + n.name).position = n.global_position + Vector2(8, 8)

func _input(event):
	if selection_opened == null:
		return
	if event.is_action_pressed("left"):
		cycle_programs("left")
	elif event.is_action_pressed("right"):
		cycle_programs("right")
	else:
		get_node(selection_opened).grab_focus()

func cycle_programs(cycle):
	if available_programs.size() == 1:
		return
	if cycle == "right" && array_selected < available_programs.size() - 1:
		array_selected += 1
	elif cycle == "left" && array_selected > 0:
		array_selected -= 1
	set_program_sprites()

func on_button_pressed(slot):
	if selection_opened != null:
		confirm_loadout(slot)
	else:
		get_parent().get_parent().hide()
		get_parent().get_parent().show()
		open_program_selection(slot)

func confirm_loadout(slot):
	var selected_program = available_programs[array_selected].duplicate(15)
	selected_program.position = Vector2.ZERO
	progress_manager.select_loadout(slot, selected_program)
	for n in available_programs:
		remove_child(n)
		if n.name == "Empty":
			n.queue_free()
		else:
			match slot:
				"LeftHand", "RightHand":
					progress_manager.get_node("OwnedPrograms/Hands").add_child(n)
				_:
					progress_manager.get_node("OwnedPrograms/" + slot).add_child(n)
	selection_opened = null
	available_programs = null
	set_slots()
	get_tree().get_first_node_in_group("MouseToolTip").hide()

func open_program_selection(slot):
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
	set_program_sprites()

func set_program_sprites():
	for i in available_programs.size():
		available_programs[i].position = get_node(selection_opened).position + Vector2(((i - array_selected) * 64) + 20, 20)
		available_programs[i].show()
