extends ColorRect

var selection_opened = null
var available_programs
var array_selected
var loaded_slots = 0

@export var max_loads = 1

var progress_manager
var info

@onready var empty = preload("res://Scenes/Programs/Empty.tscn")

func _ready():
	progress_manager = get_tree().get_first_node_in_group("ProgressManager")
	info = get_parent().get_node("Info/Label")
	await get_tree().create_timer(0.02).timeout
	set_slots()

func set_slots():
	loaded_slots = 0
	progress_manager.get_node("Loadout").show()
	for n in get_children():
		if n.name == "Label":
			continue
		var v = progress_manager.get_node("Loadout/" + n.name)
		v.global_position = n.global_position + Vector2(8, 8)
		if v.get_child_count() > 0:
			v.get_child(0).monitorable = true
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
	if selection_opened != null:
		confirm_loadout(slot)
	else:
		if loaded_slots >= max_loads && progress_manager.get_node("Loadout/" + slot).get_child_count() == 0:
			info.text = "max program quantity reach"
			return
		open_program_selection(slot)

func confirm_loadout(slot):
	var selected_program = available_programs[array_selected].duplicate(15)
	selected_program.position = Vector2.ZERO
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
				_:
					progress_manager.get_node("OwnedPrograms/" + slot).add_child(n)
	selection_opened = null
	available_programs = null
	set_slots()
	get_tree().get_first_node_in_group("MouseToolTip").hide()
	get_node(slot).grab_focus()

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
			n.monitorable = true
	set_program_sprites()

func set_program_sprites():
	for i in available_programs.size():
		available_programs[i].position = get_node(selection_opened).position + Vector2(((i - array_selected) * 64) + 20, 20)
		available_programs[i].show()


func _on_focus_entered(slot):
	if progress_manager.get_node("Loadout/" + slot).get_child_count() == 1:
		info.text = slot + "\n" + progress_manager.get_node("Loadout/" + slot).get_child(0).name + "\n" + progress_manager.get_node("Loadout/" + slot).get_child(0).info
	else:
		info.text = slot + "\n" + "Empty"

func _on_focus_exited():
	info.text = ""
