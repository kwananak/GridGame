extends "res://Scripts/Programs/program.gd"

func _ready():
	info = "Action : Shoot 1 bullet in front"
	super._ready()

func loaded():
	active = true
	super.loaded()

func action():
	focus = true
	player.waiting_for_action = self
	player.projectile_check(self)

func cancel_action():
	focus = false
	player.waiting_for_action = null
	player.move_check(player.step)

func confirm_with_dir(dir):
	focus = false
	var bullet = load("res://Scenes/Prefabs/player_bullet.tscn").instantiate()
	level_manager.add_child(bullet)
	bullet.position = dir.global_position
	bullet.rotation = dir.rotation
	bullet.direction = dir.position
	player.waiting_for_action = null
