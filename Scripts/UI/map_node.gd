extends Control

@export var available = false : set = set_available

@export var node_level : int
@export_enum("pink", "green", "yellow") var node_color : String

var selected = false : set = set_selected
var moused = false
var completed = false

func _ready():
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

func set_selected(value):
	selected = value
	$SelectedSprite.visible = value
	if value:
		for n in get_tree().get_nodes_in_group("MapNodes"):
			if n != self:
				n.selected = false
		get_tree().get_first_node_in_group("TerminalScene")._on_level_pressed(node_level)
	else:
		get_tree().get_first_node_in_group("TerminalScene")._on_level_pressed(null)

func set_available(value):
	available = value
	for n in get_children():
		match n.name:
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
	get_tree().get_first_node_in_group("LevelNameLabel").text = $/root/Main.get_level_name(node_level)
	get_tree().get_first_node_in_group("MapFrame").visible = true

func _on_focus_exited():
	if get_tree().get_first_node_in_group("LevelNameLabel") == null:
		return
	$FocusSprite.visible = false
	get_tree().get_first_node_in_group("LevelNameLabel").text = ""
	get_tree().get_first_node_in_group("MapFrame").visible = false

func _on_mouse_entered():
	if focus_mode == FOCUS_NONE:
		return
	grab_focus()
	moused = true

func _on_mouse_exited():
	moused = false
