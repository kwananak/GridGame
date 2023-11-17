extends Area2D

var tile_type = "player"
var ray
var animated_sprite_2d
var moving = false
var inputs = {"left": Vector2.LEFT,
			"right": Vector2.RIGHT,
			"up": Vector2.UP,
			"down": Vector2.DOWN,
			"skip_turn": Vector2.ZERO,
			"pause": Vector2.ONE}

@onready var level_manager = $"../LevelManager"
@onready var start_tile = $"../Environment/Floor/StartTile"

func _ready():
	animated_sprite_2d = get_node("AnimatedSprite2D")
	ray = get_node("RayCast2D")
	position = start_tile.position.snapped(Vector2.ONE * level_manager.tile_size)
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2(1, 1), 0.8).set_trans(Tween.TRANS_SINE)

func _unhandled_input(event):
	if moving:
		return
	for dir in inputs.keys():
		if event.is_action_pressed(dir):
			if inputs[dir] == inputs.pause:
				level_manager.pause_game()
				return
			if level_manager.paused:
				return
			if inputs[dir] == inputs.left:
				animated_sprite_2d.flip_h = true
			if inputs[dir] == inputs.right:
				animated_sprite_2d.flip_h = false
			if inputs[dir] == inputs.skip_turn:
				moving = true
				await level_manager.end_turn(level_manager.turn + 1)
				moving = false
				return
			collision_check(dir)

# checks for collision before moving or taking appropriate action
func collision_check(dir):
	if level_manager.game_over:
		return
	ray.target_position = inputs[dir] * level_manager.tile_size
	ray.force_raycast_update()
	if !ray.is_colliding():
		move(dir)
	else:
		var collision = ray.get_collider()
		if not "tile_type" in collision:
			return
		match collision.tile_type:
			"hardened":
				moving = true
				collision.hit_by_player()
				await level_manager.end_turn(level_manager.turn + 1)
				moving = false
			"key":
				collision.pick_up_key()
				move(dir)
			"door":
				if collision.unlocked: 
					collision.open_door()
					move(dir)
			"freeze":
				collision.set_freeze_strength()
				move(dir)
			_:
				return

# grid based character movement
func move(dir):
		moving = true
		var tween = create_tween()
		tween.tween_property(self, "position",
				position + inputs[dir] * level_manager.tile_size,
				1.5/level_manager.animation_speed).set_trans(Tween.TRANS_SINE)
		animated_sprite_2d.play("move")
		await tween.finished
		animated_sprite_2d.play("idle")
		await level_manager.end_turn(level_manager.turn + 1)
		moving = false
