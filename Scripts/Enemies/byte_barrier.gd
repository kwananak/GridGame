extends Area2D

var tile_type = "hardened"
var level_manager
var strength = 3 : set = match_strength

@export var byte_type : int

@onready var label = $Label
@onready var sprite = $AnimatedSprite2D

# calls _match_strength when game starts
func _ready():
	strength = byte_type
	$Audio.pitch_scale -= float(byte_type) / 10
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
		await spawn_explosion()
		queue_free()
	else:
		strength = value
		var saved_frame = sprite.frame
		sprite.animation = str(strength)
		sprite.frame = saved_frame
		label.text = str(strength)

func spawn_explosion():
		var explo = load("res://Scenes/Prefabs/byte_explosion.tscn").instantiate()
		get_parent().add_child(explo)
		explo.start_explosion(byte_type, position)

# called when player hits the tile
func hit_by_player(hit):
	sprite.frame = 1
	$Audio.play()
	await get_tree().create_timer(0.1).timeout
	sprite.frame = 0
	if hit is Object:
		strength = 0
	else:
		strength -= hit
