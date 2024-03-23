extends Area2D

var tile_type = "hardened"
var level_manager
var strength = 3 : set = match_strength
var destroyed_by_wall = false

@export var byte_type : int

@onready var label = $Label
@onready var sprite = $AnimatedSprite2D

# calls _match_strength when game starts
func _ready():
	strength = byte_type
	$Audio.pitch_scale -= float(byte_type) / 5
	level_manager = get_tree().get_first_node_in_group("VirtualLevelManager")
	if level_manager.vision:
		label.rotation = -rotation
		label.global_position += Vector2(-16, -16)
		label.text = str(strength)
		label.show()

# matches visual to strength and creates explosion on destruction
func match_strength(value):
	if value <= 0:
		if !destroyed_by_wall:
			level_manager.barriers_down[byte_type - 1] += 1
			level_manager.barrier_down.emit()
		level_manager.astar_grid.set_point_solid(Vector2i(position) / level_manager.tile_size, false)
		await spawn_explosion()
		queue_free()
	else:
		strength = value
		var saved_frame = sprite.frame
		sprite.animation = str(strength)
		sprite.frame = saved_frame
		label.text = str(strength)

# instantiates an explosion on root based on barrier type
func spawn_explosion():
	if !get_tree().get_first_node_in_group("FramedChecker").check(position):
		return
	var explo = load("res://Scenes/Prefabs/byte_explosion.tscn").instantiate()
	get_parent().add_child(explo)
	explo.start_explosion(byte_type, position)

# called when player hits the tile
func hit_by_player(hit):
	if get_tree().get_first_node_in_group("FramedChecker").check(position):
		sprite.frame = 1
		$Audio.play()
		for i in randi_range(3, 5):
			sprite.position = Vector2(randi_range(-3, 3), randi_range(-3, 3))
			await get_tree().create_timer(0.05).timeout
		sprite.position = Vector2.ZERO
		sprite.frame = 0
	if hit is int:
		strength -= hit
	else:
		if hit.is_in_group("VirtualPlayer"):
			strength -= hit.strength
		else:
			destroyed_by_wall = true
			strength = 0
