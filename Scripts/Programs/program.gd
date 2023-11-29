extends Node2D

var progress_manager
var virtual_level_manager
var recharge = 0
var duration = 0
var usable = false
var info : String

func _ready():
	progress_manager = get_tree().get_first_node_in_group("ProgressManager")

func loaded():
	virtual_level_manager = get_tree().get_first_node_in_group("VirtualLevelManager")

func action():
	pass

func recharging():
	pass

func end_turn():
	pass

func cancel_action():
	pass
