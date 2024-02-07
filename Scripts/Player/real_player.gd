extends "res://Scripts/Player/player.gd"

var active = false
@export var speed = 100
@onready var debug_raycast = $DebugRaycast
@onready var debug_raycast_2 = $DebugRaycast2
@onready var ray_2 = $RayCast2D2
var rays

func _ready():
	level_manager = get_tree().get_first_node_in_group("RealLevelManager")
	await enter_level_animation()
	active = true
	rays = [ray, ray_2]

func _process(delta):
	get_input(delta)
	debug_raycast.position = ray.target_position
	debug_raycast_2.position = ray_2.target_position

# checks for pressed or held direction keys
func get_input(delta):
	if level_manager.game_over || level_manager.paused || !active:
		return
	var input_direction  = Input.get_vector("left", "right", "up", "down")
	if input_direction != Vector2.ZERO:
		animated_sprite_2d.animation = "move"
		if !animated_sprite_2d.is_playing():
				animated_sprite_2d.play()
		if !$Footsteps.is_playing():
			$Footsteps.play()
	else:
		animated_sprite_2d.animation = "idle";
		if !animated_sprite_2d.is_playing():
				animated_sprite_2d.play()
	if input_direction.x < 0:
		animated_sprite_2d.flip_h = true
	if input_direction.x > 0:
		animated_sprite_2d.flip_h = false
	collision_check(input_direction, delta)

# checks for pause input
func _input(_event):
	if _event.is_action_pressed("pause"):
		level_manager.press_pause()

# free roam movements
func move(dir, delta):
	position += dir * speed * delta

# called when entering a level for a little walk-in animation
func enter_level_animation():
	moving = true
	position = get_tree().get_first_node_in_group("StartTile").position.snapped(Vector2.ONE * level_manager.tile_size)
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2(1, 1), 0.8).set_trans(Tween.TRANS_SINE)
	await tween.finished
	moving = false

# checks for collision before moving or taking appropriate action
func collision_check(dir, delta):
	for i in rays.size():
		if i == 0:
			if dir.x == 0:
				rays[i].position = Vector2(-4, 2)
			else:
				rays[i].position = Vector2(0, 4)
		else:
			if dir.x == 0:
				rays[i].position = Vector2(4, 2)
			else:
				rays[i].position = Vector2(0, 12)
		rays[i].target_position = rays[i].position + dir * 10
		rays[i].force_raycast_update()
		if ray.is_colliding():
			var collision = ray.get_collider()
			if collision.is_in_group("Terminal"):
				level_manager.call_terminal(collision.name)
				return
			if collision.get("tile_type") :
				match collision.tile_type:
					"door":
						if collision.unlocked: 
							collision.open_door()
							move(dir, delta)
			return
	move(dir, delta)
