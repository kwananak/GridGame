extends "res://Scripts/Enemies/beam_tile.gd"

@onready var skull_sprite = $SkullSprite

# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()
	skull_sprite.rotation = -rotation
	skull_sprite.frame = randi_range(0, skull_sprite.sprite_frames.get_frame_count("default") - 1)
	skull_sprite.play()

func hit_by_player(strength):
	await super.hit_by_player(strength)
	if is_destroyed:
		skull_sprite.hide()
