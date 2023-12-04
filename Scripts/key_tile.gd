extends Area2D

var level_manager
var tile_type = "key"

# set up the key type from the inspector
@export_category("Setup")
@export_enum("blue", "pink", "yellow") var key_type : String

@onready var animated_sprite_2d = $AnimatedSprite2D

func _ready():
	level_manager = get_tree().get_first_node_in_group("VirtualLevelManager")
	match_key()

# matches sprite to key type
func match_key():
	animated_sprite_2d.play(key_type)
	animated_sprite_2d.frame = randi_range(0, 4)

# adds key to level_manager and removes key tile
func pick_up(_area):
	level_manager.keys += [key_type]
	queue_free()
