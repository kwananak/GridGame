extends Area2D

# set up key(s) needed to open door from inspector
@export var keys_needed = 1
@export var key_type = Color.GREEN

@onready var animation_player = $"Label/AnimationPlayer"
@onready var level_manager = $"../../../LevelManager"
@onready var label = $"Label"

func _ready():
	label.text = str(keys_needed)
	label.set("theme_override_colors/font_color", key_type)

# called by player with the right key(s)
# makes the tile available for path finding, removes the key(s) used and removes the door
func open_door():
	level_manager.astar_grid.set_point_solid(Vector2i(position) / level_manager.tile_size)
	for n in keys_needed:
		level_manager.keys.erase(key_type)
		level_manager.set_keys(level_manager.keys)
	queue_free()

# pulsates the key requirements when player tries to open the door without the needed key(s)
func pulsate():
	animation_player.play("pulse")
