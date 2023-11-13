extends Area2D

@export var speed = 1

@onready var level_manager = $"../../../LevelManager"
@onready var player = $"../../../Player"
@onready var animated_sprite_2d = $"AnimatedSprite2D"

@export var cell_size = Vector2i(32, 32)

var astar_grid = AStarGrid2D.new()
var grid_size

func _ready():
	initialize_grid()

func initialize_grid():
	grid_size = Vector2i(get_viewport_rect().size) / cell_size
	astar_grid.size = grid_size
	astar_grid.cell_size = cell_size
	astar_grid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	astar_grid.default_estimate_heuristic = AStarGrid2D.HEURISTIC_OCTILE
	astar_grid.update()
	for wall in $"../../../Environment/Walls".get_children():
		astar_grid.set_point_solid(Vector2i(wall.position) / cell_size, true)


## Handles level manager's end_turn_call by moving towards next player
## Must subscribe to level manager calls
func turn_call():
	if level_manager.turn % speed !=0:
		return
	var direction = position.direction_to(astar_grid.get_id_path(Vector2i(position / 32), Vector2i(player.position / 32))[1] * 32)
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
