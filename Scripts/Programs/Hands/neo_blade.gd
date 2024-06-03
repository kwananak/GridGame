extends "res://Scripts/Programs/program.gd"

const strength = 5

func _ready():
	type = "NeoBlade"
	info = "Action : Destroy enemies and Byte Barriers around you"
	super._ready()

func loaded():
	active = true
	super.loaded()

func action():
	focus = true
	$LoadedSprite/Button.frame = 1
	player.moving = true
	for n in player.possible_moves:
		n.hide()
	player.get_node("AnimationPlayer").play("neo_blade")
	await get_tree().create_timer(0.5).timeout
	$Audio.play()
	for dir in player.all_dir:
		player.ray.target_position = dir * (level_manager.tile_size * 1.5)
		player.ray.force_raycast_update()
		var collision = player.ray.get_collider()
		if collision:
			if collision.is_in_group("Enemies") || collision.is_in_group("AccessPoint") || collision.name.begins_with("Mobile"):
				collision.hit_by_player(self)
			elif collision.has_method("hit_by_player"):
				collision.hit_by_player(strength)
	await player.get_node("AnimationPlayer").animation_finished
	focus = false
	level_manager.end_turn()
