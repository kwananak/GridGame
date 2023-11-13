extends Area2D

# set up the strength of the tile from the inspector
@export var strength = 1

@onready var sprite = $Sprite2D

# calls _match_strength when game starts
func _ready():
	match_strength()

# matches visual to strength
func match_strength():
	match strength:
		3:
			sprite.texture = load("res://Sprites/Pink.png")
		2:
			sprite.texture = load("res://Sprites/Brown.png")
		1:
			sprite.texture = load("res://Sprites/Yellow.png")
		0:
			queue_free()

# called when player hits the tile
func hit_by_player():
	strength -= 1
	match_strength()
