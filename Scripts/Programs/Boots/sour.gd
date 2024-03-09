extends "res://Scripts/Programs/program.gd"

var distance = 3

func _ready():
	type = "Sour"
	info = "Action : Teleport " + str(distance) + " tiles"
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

func confirm_with_dir(dir):
	var tele = dir.available_action
	if tele:
		tele.monitoring = false
		tele.hide()
		tele.global_position = Vector2.ZERO
	var pos = player.global_position
	player.move(dir.global_position)
	await get_tree().create_timer(0.3).timeout
	if tele:
		tele.global_position = pos
		tele.show()
		tele.monitoring = true
	focus = false
	player.waiting_for_action = null
	player.teleport = false
