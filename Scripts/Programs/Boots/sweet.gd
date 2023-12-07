extends "res://Scripts/Programs/program.gd"

var distance = 4

func _ready():
	info = "Action : Jump 4 in front (obstacle block the jump)"
	active = true
	super._ready()

func cancel_action():
	player.waiting_for_action = null
	focus = false
	player.move_check(player.step)

func action():
	player.waiting_for_action = self
	focus = true
	player.move_check(distance)

func confirm():
	focus = false
