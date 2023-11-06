extends Area2D

@onready var level_manager = $"../LevelManager"

var speed = 1
var tile_size = 16
var animation_speed = 12

func _process(_delta):
	if level_manager.turn % speed == 0:
			var tween = create_tween()
			tween.tween_property(self,
				"position",
				Vector2(level_manager.turn / level_manager.firewall_speed - 1, 0.0) * tile_size, 
				1.0/animation_speed).set_trans(Tween.TRANS_SINE)
			await tween.finished

# called when firewall hits player
func _on_area_entered(_area):
	level_manager.call_game_over()
