extends Control

@export var available = false : set = set_available

@export var node_level : int
@export_enum("pink", "green", "yellow") var node_color : String

var selected = false : set = set_selected
var moused = false

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
	if event is InputEventMouseButton:
		if event.is_pressed() && event.button_index == 1 && moused:
			selected = !selected

func set_selected(value):
	selected = value
	$SelectedSprite.visible = value
	if value:
		for n in get_tree().get_nodes_in_group("MapNodes"):
			if n == self:
				continue
			n.selected = false
		get_tree().get_first_node_in_group("TerminalScene")._on_level_pressed(node_level)

func set_available(value):
	available = value
	$AvailableSprite.visible = value
	if available:
		focus_mode = Control.FOCUS_ALL
	else:
		focus_mode = Control.FOCUS_NONE

func _on_focus_entered():
	$FocusSprite.visible = true

func _on_focus_exited():
	$FocusSprite.visible = false

func _on_mouse_entered():
	if focus_mode == FOCUS_NONE:
		return
	grab_focus()
	moused = true

func _on_mouse_exited():
	moused = false
