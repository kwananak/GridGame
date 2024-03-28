extends "res://Scripts/Enemies/beam_tile.gd"

@onready var skull_sprite = $SkullSprite

# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()
	skull_sprite.rotation = -rotation
	await get_tree().create_timer(float(randi_range(1, 20)) / 10).timeout
	skull_sprite.play()

func hit_by_player(strength):
	await super.hit_by_player(strength)
	if is_destroyed:
		skull_sprite.pause()
		skull_sprite.frame = 0
