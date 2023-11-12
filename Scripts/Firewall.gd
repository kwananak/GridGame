extends Area2D

@onready var level_manager = $"../LevelManager"

# moves wall right when called by level manager
func turn_call():
	if level_manager.turn % level_manager.firewall_speed == 0:
			var tween = create_tween()
			tween.tween_property(self,
				"position",
				Vector2(level_manager.turn / level_manager.firewall_speed - 1, 0.0) * level_manager.tile_size * level_manager.firewall_step, 
				1.0/(level_manager.animation_speed * 2)).set_trans(Tween.TRANS_SINE)
			await tween.finished

# called when firewall hits player
func _on_area_entered(_area):
	level_manager.call_game_over()
