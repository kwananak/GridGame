extends "res://Scripts/Player/player.gd"

var active = false

@export var speed = 100

func _ready():
	level_manager = get_tree().get_first_node_in_group("RealLevelManager")
	await enter_level_animation()
	active = true

func _process(delta):
	get_input(delta)

# checks for pressed or held direction keys
func get_input(delta):
	if level_manager.game_over || level_manager.paused || !active:
		return
	var input_direction  = Input.get_vector("left", "right", "up", "down")
	if input_direction != Vector2.ZERO:
		if input_direction.x < 0:
			animated_sprite_2d.flip_h = true
		if input_direction.x > 0:
			animated_sprite_2d.flip_h = false
		animated_sprite_2d.animation = "move"
		if !animated_sprite_2d.is_playing():
				animated_sprite_2d.play()
		if !$Footsteps.is_playing():
			$Footsteps.play()
		collision_check(input_direction, delta)
	else:
		animated_sprite_2d.animation = "idle";
		if !animated_sprite_2d.is_playing():
				animated_sprite_2d.play()

# checks for pause input
func _input(_event):
	if level_manager.game_over:
		return
	if _event.is_action_pressed("pause"):
		level_manager.press_pause()

# free roam movements
func move(dir, delta):
	position += dir * speed * delta

# called when entering a level for a little walk-in animation
func enter_level_animation():
	moving = true
	var level_number = $/root/Main.real_scene.name.substr($/root/Main.real_scene.name.length() -1, -1)
	if int($/root/Main.coming_from) > int(level_number):
		position = get_tree().get_first_node_in_group("EndTile").global_position.snapped(Vector2.ONE * level_manager.tile_size)
		get_tree().get_first_node_in_group("StartTile").get_node("AnimatedSprite2D").animation = "unlocked"
	else:
		position = get_tree().get_first_node_in_group("StartTile").global_position.snapped(Vector2.ONE * level_manager.tile_size)
	await create_tween().tween_property(self, "scale", Vector2(1, 1), 0.8).set_trans(Tween.TRANS_SINE).finished
	moving = false

func collision_check(_dir, _delta):
	pass


# checks for collision before moving or taking appropriate action
func legacy_collision_check(dir, delta):
	var collision = dir
	if collision.is_in_group("Terminal"):
		level_manager.call_terminal(collision.name)
		return
	if collision.get("tile_type") :
		match collision.tile_type:
			"door":
				if collision.unlocked: 
					for n in get_tree().get_nodes_in_group("EndTile"):
						if collision.global_position == n.global_position:
							if n.on:
								collision.open_door()
						move(dir,delta)
						return
					collision.open_door()
