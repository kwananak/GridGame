extends AnimatedSprite2D

func _ready():
	frame = randi_range(0, sprite_frames.get_frame_count("default") - 1)
