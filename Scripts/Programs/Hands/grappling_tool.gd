extends "res://Scripts/Programs/program.gd"

func _ready():
	info = "Action : Grappling of 5"
	active = true
	super._ready()

func action():
	focus = true
	player.waiting_for_action = self
	player.grapple_check(5)

func cancel_action():
	focus = false
	player.waiting_for_action = null
	player.move_check(player.step)

func confirm_with_dir(dir):
	focus = false
	player.grapple_hit(dir)
	player.waiting_for_action = null
