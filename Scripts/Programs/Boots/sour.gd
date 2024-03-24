extends "res://Scripts/Programs/program.gd"

var distance = 2
@onready var up = $Up
@onready var down = $Down

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
	focus = false
	$LoadedSprite/Button.frame = 1
	up.play()
	for n in player.possible_moves:
		n.hide()
	var tele = dir.available_action
	if tele:
		tele.monitorable = false
		tele.monitoring = false
		tele.hide()
		tele.global_position = Vector2.ZERO
	var pos = player.global_position
	await player.move(dir.global_position)
	down.play()
	player.waiting_for_action = null
	player.teleport = false
	if tele:
		tele.global_position = pos
		tele.show()
		tele.monitorable = true
		tele.monitoring = true
		if level_manager.astar_grid.is_point_solid(player.global_position / level_manager.tile_size):
			level_manager.astar_grid.set_point_solid(player.global_position / level_manager.tile_size, false)
			level_manager.astar_grid.set_point_solid(tele.global_position / level_manager.tile_size, true)
