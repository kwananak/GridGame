extends Area2D

var progress_manager
var level_manager
var player
var recharge = 0
var duration = 0
var focus = false
var info : String
var mouse_tip
var active = false

func _ready():
	mouse_tip = get_tree().get_first_node_in_group("MouseToolTip")
	player = get_tree().get_first_node_in_group("Player")
	progress_manager = get_tree().get_first_node_in_group("ProgressManager")

func loaded():
	level_manager = get_tree().get_first_node_in_group("VirtualLevelManager")

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
