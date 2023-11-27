extends ColorRect

var progress_manager
var selection_opened = null
var available_programs
var empty

func _ready():
	progress_manager = get_tree().get_first_node_in_group("ProgressManager")
	empty = preload("res://Scenes/Programs/Empty.tscn")
	set_slots()

func set_slots():
	progress_manager.get_node("Loadout").show()
	for n in get_children():
		if n.name == "LeftHand" || n.name == "RightHand":
			continue
		progress_manager.get_node("Loadout/" + n.name).position = n.global_position

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
	if available_programs.size() == 2 || cycle == "right":
		available_programs.push_front(available_programs.pop_back())
	else:
		available_programs.push_back(available_programs.pop_front())
	set_program_sprites()

func on_button_pressed(slot):
	if selection_opened != null:
		confirm_loadout(slot)
	else:
		get_parent().get_parent().hide()
		get_parent().get_parent().show()
		open_program_selection(slot)

func confirm_loadout(slot):
	var selected_program = available_programs.pop_front()
	selected_program.position = Vector2.ZERO
	remove_child(selected_program)
	progress_manager.select_loadout(slot, selected_program)
	for n in available_programs:
		remove_child(n)
		if n.name == "Empty":
			n.queue_free()
		else:
			progress_manager.get_node("OwnedPrograms/" + slot).add_child(n)
	get_node(selection_opened).grab_focus()
	selection_opened = null
	available_programs = null
	set_slots()

func open_program_selection(slot):
	selection_opened = slot
	var new_empty = empty.instantiate()
	available_programs = [new_empty] + progress_manager.get_available_programs(slot)
	for n in available_programs:
		add_child(n)
	set_program_sprites()

func set_program_sprites():
	for i in available_programs.size():
		available_programs[i].position = get_node(selection_opened).position + Vector2(i * 64, 0)
		available_programs[i].show()
