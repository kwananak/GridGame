extends "res://Scripts/Programs/program.gd"

var distance = 2

func _ready():
	info = "Action : Teleport 2 in front"
	super._ready()
	usable = true

func cancel_action():
	player.move_check(player.step)
	focus = false
	usable = true

func action():
	player.move_check(distance)
	player.waiting_for_action = self
	usable = false
	focus = true
