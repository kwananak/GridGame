extends CharacterBody2D

const SPEED = 100.0
const inputs = {"left": Vector2.LEFT,
			"right": Vector2.RIGHT,
			"up": Vector2.UP,
			"down": Vector2.DOWN}

var level_manager
var active = false
var floating = false
var waiting_for_action = null

@onready var animated_sprite_2d = $AnimatedSprite2D

func _ready():
	level_manager = get_tree().get_first_node_in_group("RealLevelManager")
	scale = Vector2.ZERO
	await enter_level_animation()
	active = true

# checks for pause input
func _input(_event):
	if level_manager.game_over:
		return
	if _event.is_action_pressed("pause"):
		level_manager.press_pause()

# called when entering a level for a little walk-in animation
func enter_level_animation():
	var level_number = $/root/Main.real_scene.name.substr($/root/Main.real_scene.name.length() -1, -1)
	if int($/root/Main.coming_from) > int(level_number):
		position = get_tree().get_first_node_in_group("EndTile").global_position.snapped(Vector2.ONE * level_manager.tile_size)
	else:
		position = get_tree().get_first_node_in_group("StartTile").global_position.snapped(Vector2.ONE * level_manager.tile_size)
	await create_tween().tween_property(self, "scale", Vector2(1, 1), 0.8).set_trans(Tween.TRANS_SINE).finished

func _physics_process(delta):
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
		move_and_collide(input_direction * SPEED * delta)
	else:
		animated_sprite_2d.animation = "idle";
		if !animated_sprite_2d.is_playing():
				animated_sprite_2d.play()
