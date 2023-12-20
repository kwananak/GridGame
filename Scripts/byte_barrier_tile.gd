extends Area2D

var tile_type = "hardened"
var level_manager
var strength = 3

@onready var label = $Label
@onready var sprite = $AnimatedSprite2D

# calls _match_strength when game starts
func _ready():
	sprite.frame = randi_range(0, 3)
	match_strength()
	level_manager = get_tree().get_first_node_in_group("VirtualLevelManager")
	await get_tree().create_timer(0.2).timeout
	if get_tree().get_first_node_in_group("VirtualLevelManager").vision:
		label.rotation = -rotation
		label.global_position += Vector2(-16, -16)
		label.text = str(strength)
		label.show()

# matches visual to strength
func match_strength():
	if strength <= 0:
		$CollisionShape2D.disabled = true
		level_manager.astar_grid.set_point_solid(Vector2i(position) / level_manager.tile_size, false)
		sprite.animation = "0"
		await sprite.animation_finished
		queue_free()
	else:
		var saved_frame = sprite.frame
		sprite.animation = str(strength)
		sprite.frame = saved_frame
	label.text = str(strength)

# called when player hits the tile
func hit_by_player(hit):
	if hit is Object:
		strength = 0
	else:
		strength -= hit
	match_strength()
