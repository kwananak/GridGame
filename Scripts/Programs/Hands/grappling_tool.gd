extends "res://Scripts/Programs/program.gd"

var grapple_range = 5

func _ready():
	info = "Action : Grappling of 5"
	super._ready()

func loaded():
	active = true
	super.loaded()

func action():
	focus = true
	player.waiting_for_action = self
	player.grapple_check(grapple_range)

func cancel_action():
	focus = false
	player.waiting_for_action = null
	player.move_check(player.step)

func confirm_with_dir(dir):
	focus = false
	await player.grapple_hit(dir)
