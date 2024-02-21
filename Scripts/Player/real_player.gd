extends "res://Scripts/Player/player.gd"

var active = false
var rays

@export var speed = 100
@export var debug_raycasts = false

@onready var debug_raycast = $DebugRaycast
@onready var debug_raycast_2 = $DebugRaycast2
@onready var debug_raycast_3 = $DebugRaycast3
@onready var ray_2 = $RayCast2D2
@onready var ray_3 = $RayCast2D3

func _ready():
	level_manager = get_tree().get_first_node_in_group("RealLevelManager")
	await enter_level_animation()
	active = true
	rays = [ray, ray_2, ray_3]
	if debug_raycasts:
		debug_raycast.show()
		debug_raycast_2.show()
		debug_raycast_3.show()

func _process(delta):
	get_input(delta)
	if !debug_raycast:
		return
	debug_raycast.position = ray.target_position
	debug_raycast_2.position = ray_2.target_position
	debug_raycast_3.position = ray_3.target_position

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

# checks for collision before moving or taking appropriate action
func collision_check(dir, delta):
	for i in rays.size():
		match i:
			0:
				if dir.x == 0:
					if dir.y < 0:
						rays[i].position = Vector2(0, 6)
					else:
						rays[i].position = Vector2(0, 2)
				else:
					rays[i].position = Vector2(0, 4)
			1:
				if dir.x == 0:
					if dir.y < 0:
						rays[i].position = Vector2(6, 6)
					else:
						rays[i].position = Vector2(6, 2)
				else:
					if dir.y > 0:
						rays[i].position = Vector2(0, 0)
					else:
						rays[i].position = Vector2(0, 12)
			2:
				if dir.x == 0:
					if dir.y < 0:
						rays[i].position = Vector2(-6, 6)
					else:
						rays[i].position = Vector2(-6, 2)
				else:
					if dir.y > 0:
						if dir.x > 0:
							rays[i].position = Vector2(-4, 4)
						elif dir.x < 0:
							rays[i].position = Vector2(4, 4)
					else:
						rays[i].position = Vector2(0, 8)
		rays[i].target_position = rays[i].position + dir * 12
		rays[i].force_raycast_update()
		if rays[i].is_colliding():
			var collision = rays[i].get_collider()
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
							move(dir, delta)
			return
	move(dir, delta)
