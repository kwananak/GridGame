extends Area2D

var tile_type = "hardened"

# set up the strength of the tile from the inspector
@export var strength = 1

# calls _match_strength when game starts
func _ready():
	match_strength()

# matches visual to strength
func match_strength():
	if strength <= 0:
		queue_free()
	else:
		$"AnimatedSprite2D".frame = strength - 1

# called when player hits the tile
func hit_by_player(hit):
	strength -= hit
	match_strength()
