extends Area2D

var animated_sprite_2d

@export var speed = 1

@onready var level_manager = $"../../../LevelManager"
@onready var player = $"../../../Player"

func _ready():
	animated_sprite_2d = get_node("AnimatedSprite2D")

## Handles level manager's end_turn_call by moving towards next player
## Must subscribe to level manager calls
func turn_call():
	if level_manager.turn % speed !=0:
		return
	var direction = position.direction_to(player.position)
	if direction.x > 0:
		animated_sprite_2d.flip_h = false
	if direction.x < 0:
		animated_sprite_2d.flip_h = true
	var tween = create_tween()
	tween.tween_property(self, "position",
		position + direction * 
			level_manager.tile_size, 1.0/level_manager.animation_speed).set_trans(Tween.TRANS_SINE)
	animated_sprite_2d.play("move")
	await tween.finished
	animated_sprite_2d.play("idle")

# called when enemy hits player
func _on_area_entered(_area):
	level_manager.call_game_over()
