extends "res://Scripts/Programs/program.gd"

var strength = 1

func _ready():
	info = "Action : Hit 3 blocks in front of you"
	active = true
	super._ready()

func action():
	focus = true
	player.waiting_for_action = self
	player.row_check(3)

func cancel_action():
	focus = false
	player.waiting_for_action = null
	player.clean_row_checker()
	player.move_check(player.step)

func confirm_with_dir(dir):
	focus = false
	player.waiting_for_action = null
	player.row_hit(dir)
