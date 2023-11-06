extends Area2D

var ray
var animated_sprite_2d
@onready var level_manager = $"../LevelManager"
@onready var start_tile = $"../Environment/Floor/StartTile"

var animation_speed = 6
var moving = false
var tile_size = 32
var inputs = {"left": Vector2.LEFT,
			"right": Vector2.RIGHT,
			"up": Vector2.UP,
			"down": Vector2.DOWN}

func _ready():
	animated_sprite_2d = get_node("AnimatedSprite2D")
	ray = get_node("RayCast2D")
	position = start_tile.position.snapped(Vector2.ONE * tile_size)
	position += Vector2.ONE * tile_size/2

func _process(_delta):
	if level_manager.game_over and !level_manager.game_won:
		animated_sprite_2d.play("tumble")

func _unhandled_input(event):
	if moving:
		return
	for dir in inputs.keys():
		if event.is_action_pressed(dir):
			move(dir)

func move(dir):
	if level_manager.game_over:
		return
	ray.target_position = inputs[dir] * tile_size
	ray.force_raycast_update()
	if !ray.is_colliding():
		var tween = create_tween()
		tween.tween_property(self, "position",
			position + inputs[dir] * tile_size, 1.0/animation_speed).set_trans(Tween.TRANS_SINE)
		moving = true
		await tween.finished
		moving = false
		level_manager.turn += 1
	else:
		if ray.get_collider().name == "HardenedTile":
			ray.get_collider().hit_by_player()
			level_manager.turn += 1
