extends Area2D

var level_manager
var flipper = 0

func _ready():
	level_manager = get_tree().get_first_node_in_group("RealLevelManager")

func _on_body_entered(body):
	if flipper > 0 || !body.is_in_group("RealPlayer"):
		return
	flipper = 1
	level_manager.call_terminal(get_parent().name)

func _on_body_exited(body):
	if !body.is_in_group("RealPlayer"):
		return
	flipper += 1
	if flipper > 2:
		flipper = 0
