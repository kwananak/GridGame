extends Control

@onready var main = $/root/Main

@export var available = false : set = set_available
@export var node_level : int
@export_enum("pink", "blue", "purple", "aqua") var node_color : String

var selected = false : set = set_selected
var moused = false
var completed = false : set = set_completed
var progress_manager
var map_frame
var name_label
var terminal_scene
var access_point_label
var program_label
var difficulty_label
var loadout

func _ready():
	progress_manager =  get_tree().get_first_node_in_group("ProgressManager")
	terminal_scene = get_tree().get_first_node_in_group("TerminalScene")
	map_frame = get_tree().get_first_node_in_group("MapFrame")
	name_label = get_tree().get_first_node_in_group("LevelNameLabel")
	access_point_label = get_tree().get_first_node_in_group("AccessPointLabel")
	program_label = get_tree().get_first_node_in_group("ProgramLabel")
	difficulty_label = get_tree().get_first_node_in_group("DifficultyLabel")
	loadout = get_tree().get_first_node_in_group("Loadout")
	if node_color != "aqua":
		$SelectedSprite.animation = node_color
	if available:
		focus_mode = Control.FOCUS_ALL

func _input(event):
	if !available:
		return
	if has_focus():
		if event.is_action_pressed("ui_accept"):
			selected = !selected
			return
		if event is InputEventMouseButton:
			if event.is_pressed() && event.button_index == 1 && moused:
				selected = !selected

func set_completed(value):
	completed = value
	$CompletedSprite.visible = completed

func set_selected(value):
	selected = value
	$SelectedSprite.visible = value
	if value:
		for n in get_tree().get_nodes_in_group("MapNodes"):
			if n != self:
				n.selected = false
		terminal_scene._on_level_pressed(node_level)
	else:
		terminal_scene._on_level_pressed(null)

func set_available(value):
	available = value
	for n in get_children():
		match n.name:
			"IncompleteSprite":
				if available:
					n.visible = true
			"LinkSprite":
				if !completed:
					n.get_node("AnimationPlayer").play("new_animation")
				else:
					n.visible = true
			"CompletedSprite":
				if completed:
					n.visible = true
	if available:
		focus_mode = Control.FOCUS_ALL
	else:
		focus_mode = Control.FOCUS_NONE

func _on_focus_entered():
	$FocusSprite.visible = true
	name_label.text = main.get_level_name(node_level)
	set_labels()
	map_frame.visible = true

func _on_focus_exited():
	if name_label == null:
		return
	$FocusSprite.visible = false
	clear_labels()
	map_frame.visible = false

func _on_mouse_entered():
	if focus_mode == FOCUS_NONE || loadout.selection_opened:
		return
	grab_focus()
	moused = true

func _on_mouse_exited():
	moused = false

func set_labels():
	var access_unlocked = [0,0]
	for k in progress_manager.levels[str(node_level)]:
		match k:
			"prog":
				if progress_manager.levels[str(node_level)][k]:
					program_label.append_text("[color=green]Program Found")
				else:
					program_label.append_text("[color=red]Program Not Found")
			"name":
				name_label.text = progress_manager.levels[str(node_level)][k]
			"difficulty":
				difficulty_label.texture.region = Rect2(0, 0, float(progress_manager.levels[str(node_level)][k]) * 12 + 1, 16)
				difficulty_label.show()
			"0":
				continue
			_:
				access_unlocked[1] += 1
				if progress_manager.levels[str(node_level)][k]:
					access_unlocked[0] += 1
	if access_unlocked[1] == 0:
		return
	if access_unlocked[0] == access_unlocked[1]:
		access_point_label.append_text("[color=green]")
	else:
		access_point_label.append_text("[color=red]")
	access_point_label.append_text("Access Point")
	if access_unlocked[1] > 1:
		access_point_label.append_text("s")
	access_point_label.append_text(": " + str(access_unlocked[0]) + "/" + str(access_unlocked[1]))

func clear_labels():
	name_label.text = ""
	access_point_label.clear()
	program_label.clear()
	difficulty_label.hide() 
