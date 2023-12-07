extends "res://Scripts/Programs/program.gd"

func _ready():
	info = "Action : Shoot 1 bullet in front"
	super._ready()
	usable = true

func action():
	usable = false
	focus = true
	player.waiting_for_action = self
	player.projectile_check(self)

func cancel_action():
	focus = false
	usable = true
	player.waiting_for_action = null
	player.projectile_uncheck(self)

func confirm_with_dir(dir):
	focus = false
	var bullet = load("res://Scenes/Prefabs/player_bullet.tscn").instantiate()
	level_manager.add_child(bullet)
	bullet.position = dir.global_position
	bullet.rotation = dir.rotation
	bullet.direction = dir.position
	player.projectile_uncheck(self)
