extends AnimatedSprite2D

func start_explosion(type, pos):
	position = pos
	animation = str(type)
	$AudioStreamPlayer.pitch_scale -= float(type) / 10
	show()
	$AudioStreamPlayer.play()
	play()
	await animation_finished
	queue_free()
