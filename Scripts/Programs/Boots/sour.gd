extends "res://Scripts/Programs/program.gd"

var distance = 2

func _ready():
	info = "Action : Teleport 2 in front"
	super._ready()
	usable = true

func cancel_action():
	focus = false
	usable = true
	player.waiting_for_action = null
	player.teleport = false
	player.move_check(player.step)

func action():
	usable = false
	focus = true
	player.waiting_for_action = self
	player.teleport = true
	player.move_check(distance)

func confirm():
	player.teleport = false
	focus = false
