extends StaticBody2D

func _ready():
	$AudioStreamPlayer.pitch_scale = randf_range(0.95, 1.05)

func _on_animated_sprite_2d_frame_changed():
	if $AnimatedSprite2D.frame == 1:
		$AudioStreamPlayer.play()
