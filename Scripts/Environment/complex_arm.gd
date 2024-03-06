extends StaticBody2D

const points = [Vector2(103, 109),
				Vector2(102, 94),
				Vector2(111, 74),
				Vector2(103, 65),
				Vector2(91, 73)]

var loaded_limb

@export var limb : int
@onready var sprite = $AnimatedSprite2D

func _ready():
	$AudioStreamPlayer.pitch_scale = randf_range(0.95, 1.05)
	$LimbSprite.frame = limb

func _on_animated_sprite_2d_frame_changed():
	if sprite.frame == 1:
		$AudioStreamPlayer.play()
	if sprite.frame > 3 && sprite.frame < 8:
		$LimbSprite.position = points[sprite.frame - 3]
