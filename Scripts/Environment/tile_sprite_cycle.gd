extends Node2D

func _ready():
	$AnimatedSprite2D.frame = int(position.x / 32) % $AnimatedSprite2D.sprite_frames.get_frame_count("default")
