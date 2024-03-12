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
	for n in player.possible_moves:
		n.hide()
	var tele = dir.available_action
	if tele:
		tele.monitoring = false
		await create_tween().tween_property(tele, "scale", Vector2(0.5, 0.5), 0.05).finished
		tele.hide()
		tele.global_position = Vector2.ZERO
	var pos = player.global_position
	player.move(dir.global_position)
	await get_tree().create_timer(0.3).timeout
	focus = false
	player.waiting_for_action = null
	player.teleport = false
	if tele:
		tele.global_position = pos
		tele.show()
		create_tween().tween_property(tele, "scale", Vector2.ONE, 0.05)
		tele.monitoring = true
