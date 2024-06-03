extends AnimatedSprite2D

var counter = 0.0

func _process(delta):
	counter -= delta
	if counter < 0.0:
		frame = randi_range(0, sprite_frames.get_frame_count("default") - 1)
		counter = randf_range(0.3, 2.0)
