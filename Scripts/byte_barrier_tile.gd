extends Area2D

var tile_type = "hardened"
var level_manager
var strength = 3 : set = match_strength

@onready var label = $Label
@onready var sprite = $AnimatedSprite2D

# calls _match_strength when game starts
func _ready():
	sprite.frame = randi_range(0, 3)
	level_manager = get_tree().get_first_node_in_group("VirtualLevelManager")
	if get_tree().get_first_node_in_group("VirtualLevelManager").vision:
		label.rotation = -rotation
		label.global_position += Vector2(-16, -16)
		label.text = str(strength)
		label.show()

# matches visual to strength and creates explosion on destruction
func match_strength(value):
	if value <= 0:
		level_manager.astar_grid.set_point_solid(Vector2i(position) / level_manager.tile_size, false)
		var explo = load("res://Scenes/Prefabs/byte_explosion.tscn").instantiate()
		get_parent().add_child(explo)
		explo.position = position
		queue_free()
	else:
		strength = value
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
