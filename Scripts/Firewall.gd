extends Area2D

var level_manager
var adjustment = 0
var skip_turn = false
@onready var sprite = $AnimatedSprites

func _ready():
	level_manager = get_tree().get_first_node_in_group("VirtualLevelManager")

# moves wall right when called by level manager
func turn_call():
	if skip_turn:
		skip_turn = false
		return
	if level_manager.turn % level_manager.firewall_speed == 0:
		var old_pos = position
		position = Vector2(level_manager.turn / level_manager.firewall_speed - 1 + adjustment, 0.0) * level_manager.tile_size * level_manager.firewall_step
		sprite.global_position = old_pos
		animate_wall()

func animate_wall():
	var tween = create_tween()
	tween.tween_property($AnimatedSprites, "position",
			Vector2.ZERO, 
			1.5 / (level_manager.animation_speed * 2)
			).set_trans(Tween.TRANS_SINE)
	await tween.finished

# called when firewall hits player
func _on_area_entered(_area):
	level_manager.call_game_over()

func move_wall(distance):
	adjustment += distance
	var tween = create_tween()
	tween.tween_property(self, "position",
				Vector2(level_manager.turn / level_manager.firewall_speed - 1 + adjustment, 0.0)
						* level_manager.tile_size * level_manager.firewall_step, 
				1.5 / (level_manager.animation_speed * 2)
				).set_trans(Tween.TRANS_SINE)
	await tween.finished
