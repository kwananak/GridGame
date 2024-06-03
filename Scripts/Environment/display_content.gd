extends AnimatedSprite2D

var up = false
var speed

func _ready():
	if randi_range(1, 2) > 1:
		up = true
	frame = randi_range(0, sprite_frames.get_frame_count("default") - 1)
	speed = randf_range(2.0, 4.0)

func _process(delta):
	if up:
		position.y -= delta * speed
		if position.y <= -13:
			up = false
	else:
		position.y += delta * speed
		if position.y >= -9:
			up = true
