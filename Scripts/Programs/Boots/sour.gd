extends "res://Scripts/Programs/program.gd"

var distance = 2
var player
var focus = false

func _ready():
	info = "Action : Teleport 2 in front"
	super._ready()
	usable = true

func _unhandled_input(event):
	if focus == false || player.waiting_for_action != "sour":
		return
	for dir in player.inputs.keys():
		if event.is_action_pressed(dir):
			if player.distance_check_pos[player.inputs[dir]]:
				player.position += player.inputs[dir] * (virtual_level_manager.tile_size * distance)
				player.waiting_for_action = null
				focus = false
				player.remove_distance_checkers()

func cancel_action():
	player.waiting_for_action = null
	player.remove_distance_checkers()
	focus = false
	usable = true

func action():
	player = get_tree().get_first_node_in_group("Player")
	player.waiting_for_action = "sour"
	player.distance_check(distance)
	usable = false
	focus = true
