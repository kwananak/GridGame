extends "res://Scripts/level_manager.gd"

var turn = 0 : set = end_turn
var freeze = 0 : set = set_freeze

@export var firewall_speed = 1
@export var firewall_step = 0.5

func _ready():
	player = get_tree().get_first_node_in_group("VirtualPlayer")
	super._ready()

# calls subscribed nodes when player makes a move
func end_turn(value):
	if freeze > 0 :
		freeze -= 1
		return
	turn = value
	for node in get_tree().get_nodes_in_group("EndTurn"):
		await get_tree().create_timer(end_turn_speed).timeout
		node.turn_call()

# called when freeze is picked up
# shows remaining number of freezed turns, if any
func set_freeze(value):
	freeze = value
	var freeze_ui = ui.get_node("FreezeUI")
	if freeze > 0:
		freeze_ui.text = "freeze = " + str(freeze)
		freeze_ui.visible = true
	else:
		freeze_ui.visible = false
