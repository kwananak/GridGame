extends ColorRect

var progress_manager
var selection_opened = null
var available_programs

func _ready():
	progress_manager = get_tree().get_first_node_in_group("ProgressManager")
	set_slots()

func set_slots():
	for n in get_children():
		n.get_node("CenterSelection").animation = progress_manager.loadout[n.name]

func _input(event):
	if selection_opened == null:
		return
	if event.is_action_pressed("left"):
		cycle_programs("left")
	if event.is_action_pressed("right"):
		cycle_programs("right")

func cycle_programs(cycle):
	if available_programs.size() == 1:
		return
	if available_programs.size() == 2 || cycle == "left":
		available_programs.push_front(available_programs.pop_back())
	else:
		available_programs.push_back(available_programs.pop_front())
	set_program_sprites()

func on_button_pressed(slot):
	if selection_opened != null:
		confirm_loadout(slot)
	else:
		open_program_selection(slot)

func confirm_loadout(slot):
	progress_manager.select_loadout(slot, available_programs[0])
	get_node(selection_opened).get_node("LeftSelection").visible = false
	get_node(selection_opened).get_node("RightSelection").visible = false
	selection_opened = null
	available_programs = null
	set_slots()

func open_program_selection(slot):
	selection_opened = slot
	available_programs = ["empty"] + progress_manager.get_available_programs(slot)
	set_program_sprites()

func set_program_sprites():
	get_node(selection_opened).get_node("CenterSelection").animation = available_programs[0]
	if available_programs.size() > 1:
		get_node(selection_opened).get_node("LeftSelection").animation = available_programs[1]
		get_node(selection_opened).get_node("LeftSelection").visible = true
	if available_programs.size() > 2:
		get_node(selection_opened).get_node("RightSelection").animation = available_programs[2]
		get_node(selection_opened).get_node("RightSelection").visible = true
	if available_programs.size() == 2:
		get_node(selection_opened).get_node("RightSelection").animation = available_programs[1]
		get_node(selection_opened).get_node("RightSelection").visible = true
