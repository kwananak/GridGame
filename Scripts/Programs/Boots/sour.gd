extends "res://Scripts/Programs/program.gd"

var distance = 2

func _ready():
	info = "Action : Teleport 2 in front"
	super._ready()

func loaded():
	active = true
	super.loaded()

func cancel_action():
	focus = false
	player.waiting_for_action = null
	player.teleport = false
	player.move_check(player.step)

func action():
	focus = true
	player.waiting_for_action = self
	player.teleport = true
	player.move_check(distance)

func confirm():
	player.teleport = false
	focus = false
