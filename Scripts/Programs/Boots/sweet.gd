extends "res://Scripts/Programs/program.gd"

var distance = 4

func _ready():
	info = "Action : Jump 4 in front (obstacle block the jump)"
	super._ready()
	usable = true

func cancel_action():
	player.waiting_for_action = null
	focus = false
	usable = true
	player.move_check(player.step)

func action():
	player.waiting_for_action = self
	usable = false
	focus = true
	player.move_check(distance)

func confirm():
	focus = false
