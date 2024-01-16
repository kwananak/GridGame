extends Area2D

var level_manager
var moving = false
var floating = false
var waiting_for_action = null
var inputs = {"left": Vector2.LEFT,
			"right": Vector2.RIGHT,
			"up": Vector2.UP,
			"down": Vector2.DOWN}

@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var ray = $RayCast2D

# called when entering a level for a little walk-in animation
func enter_level_animation():
	moving = true
	animated_sprite_2d.play("move")
	position = get_tree().get_first_node_in_group("StartTile").position.snapped(Vector2.ONE * level_manager.tile_size)
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2(1, 1), 0.8).set_trans(Tween.TRANS_SINE)
	await tween.finished
	animated_sprite_2d.play("idle")
