extends Area2D

var progress_manager
var level_manager
var player
var recharge = 0
var duration = 0
var focus = false : set = set_focus
var info : String
var mouse_tip
var active = false
var usable = true
var runed = false
var mouse_on = false
var focus_rect = preload("res://Scenes/Programs/focus.tscn")

func _ready():
	mouse_tip = get_tree().get_first_node_in_group("MouseToolTip")
	player = get_tree().get_first_node_in_group("VirtualPlayer")
	progress_manager = get_tree().get_first_node_in_group("ProgressManager")

func loaded():
	level_manager = get_tree().get_first_node_in_group("VirtualLevelManager")
	$Sprite2D.hide()
	$LoadedSprite.show()

func picked_up(slot):
	set_deferred("monitorable", false)
	hide()
	get_tree().get_first_node_in_group("VirtualLevelManager").programs += [[slot, self]]

func action():
	pass

func recharging():
	pass

func end_turn():
	pass

func cancel_action():
	pass

func confirm():
	pass

func _on_mouse_entered():
	if get_parent().get_parent().name == "Loadout":
		if "info" in get_parent().get_parent():
			get_parent().get_parent().info.text = get_parent().name + "\n" + name + "\n" + info
	mouse_on = true

func _on_mouse_exited():
	mouse_on = false

func set_focus(value):
	focus = value
	if focus:
		add_child(focus_rect.instantiate())
	else:
		remove_child($Focus)
