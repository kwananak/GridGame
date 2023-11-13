extends Area2D

# set up the key type from the inspector (green or red)
@export var key_type = Color.GREEN

@onready var sprite = $Sprite2D

func _ready():
	match_key()

# matches sprite to key type
func match_key():
	match key_type:
		Color.GREEN:
			sprite.texture = load("res://Sprites/GreenKey.png")
		Color.RED:
			sprite.texture = load("res://Sprites/RedKey.png")

# adds key to level_manager and removes key tile
func pick_up_key():
	$"../../../LevelManager".keys += [key_type]
	queue_free()
