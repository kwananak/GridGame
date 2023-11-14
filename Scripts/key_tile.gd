extends Area2D

var tile_type = "key"

# set up the key type from the inspector
@export_enum("blue", "red", "yellow") var key_type: String

@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var level_manager = $"../../LevelManager"

func _ready():
	match_key()

# matches sprite to key type
func match_key():
	animated_sprite_2d.play(key_type)
	animated_sprite_2d.frame = randi_range(0, 4)

# adds key to level_manager and removes key tile
func pick_up_key():
	level_manager.keys += [key_type]
	queue_free()
