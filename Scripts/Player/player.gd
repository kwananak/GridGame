extends Area2D

var level_manager
var moving = false : set = set_moving
var floating = false
var waiting_for_action = null
var inputs = {"left": Vector2.LEFT,
			"right": Vector2.RIGHT,
			"up": Vector2.UP,
			"down": Vector2.DOWN}

signal moving_signal

@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var ray = $RayCast2D

# called when entering a level for a little walk-in animation
func enter_level_animation():
	moving = true
	position = get_tree().get_first_node_in_group("StartTile").position.snapped(Vector2.ONE * level_manager.tile_size)
	animated_sprite_2d.play("move")
	await create_tween().tween_property(self, "scale", Vector2(1, 1), 0.8).set_trans(Tween.TRANS_SINE).finished
	animated_sprite_2d.play("idle")

func set_moving(value):
	moving = value
	moving_signal.emit(value)
