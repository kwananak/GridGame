extends StaticBody2D

const points = [Vector2(103, 109),
				Vector2(102, 94),
				Vector2(111, 74),
				Vector2(103, 65),
				Vector2(91, 73)]

@export var limb : int
@onready var sprite = $AnimatedSprite2D
@onready var limb_sprite = $LimbSprite
@onready var bot_sprite = $BotSprite
@onready var animation_player = $AnimationPlayer

func _ready():
	$AudioStreamPlayer.pitch_scale = randf_range(0.95, 1.05)
	limb_sprite.frame = limb
	bot_sprite.frame = limb
	if limb == 7:
		sprite.hide()
		animation_player.play("conveyor_end")
	else:
		animation_player.play("new_animation")

func _on_animated_sprite_2d_frame_changed():
	match sprite.frame:
		0:
			limb_sprite.hide()
		3:
			$AudioStreamPlayer.play()
			if limb == 6:
				bot_sprite.frame = 7
		6:
			limb_sprite.show()
			limb_sprite.position = points[sprite.frame - 5]
		7, 9:
			limb_sprite.position = points[sprite.frame - 5]
		8:
			limb_sprite.position = points[sprite.frame - 5]
			if limb == 6:
				bot_sprite.frame = 6
