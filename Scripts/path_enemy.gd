extends Area2D

var animated_sprite_2d

# add path nodes and set speed from inspector. 1 will move every turn, 2 every 2 turn, etc.
@export var path_nodes : Array[Node] = []
@export var speed = 1

@onready var level_manager = $"../../../LevelManager"

func _ready():
	animated_sprite_2d = get_node("AnimatedSprite2D")

## Handles level manager's end_turn_call by moving towards next node on path
## Must subscribe to level manager calls
func turn_call():
	if level_manager.turn % speed !=0:
		return
	if position == path_nodes[0].position:
		path_nodes.push_back(path_nodes.pop_front())
	var direction = position.direction_to(path_nodes[0].position)
	match direction:
		Vector2.LEFT:
			animated_sprite_2d.flip_h = true
		Vector2.RIGHT:
			animated_sprite_2d.flip_h = false
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
