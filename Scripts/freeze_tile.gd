extends Area2D

var tile_type = "freeze"

# set up number of turn freezed after pick up, turn where item is picked up is included
@export var strength = 3

# sends freeze strength to level manager and removes freeze tile
func pick_up():
	$"../../LevelManager".freeze = strength
	queue_free()
