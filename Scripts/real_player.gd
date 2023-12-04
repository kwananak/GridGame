extends "res://Scripts/player.gd"

var active = false
@export var speed = 2

func _ready():
	level_manager = get_tree().get_first_node_in_group("RealLevelManager")
	await enter_level_animation()
	active = true

func _process(_delta):
	get_input()

# checks for pressed or held direction keys
func get_input():
	if level_manager.game_over || level_manager.paused || !active:
		return
	var input_direction  = Input.get_vector("left", "right", "up", "down")
	if input_direction.x < 0:
		animated_sprite_2d.flip_h = true
	if input_direction.x > 0:
		animated_sprite_2d.flip_h = false
	collision_check(input_direction)

# checks for pause input
func _input(_event):
	if _event.is_action_pressed("pause"):
		level_manager.press_pause()

# free roam movements
func move(dir):
	position += dir * speed

# called when entering a level for a little walk-in animation
func enter_level_animation():
	moving = true
	position = get_tree().get_first_node_in_group("StartTile").position.snapped(Vector2.ONE * level_manager.tile_size)
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2(1, 1), 0.8).set_trans(Tween.TRANS_SINE)
	await tween.finished
	moving = false

# checks for collision before moving or taking appropriate action
func collision_check(dir):
	ray.target_position = dir * 16
	ray.force_raycast_update()
	if !ray.is_colliding():
		move(dir)
	else:
		var collision = ray.get_collider()
		if collision.is_in_group("Terminal"):
			level_manager.call_terminal()
			return
		match collision.tile_type:
			"door":
				if collision.unlocked: 
					collision.open_door()
					move(dir)
