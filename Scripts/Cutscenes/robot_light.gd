extends Sprite2D

var counter = 0.0

func _ready():
	texture = texture.duplicate()

func _process(delta):
	counter -= delta
	if counter < 0.0:
		texture.region = Rect2(0.0, float(randi_range(0, 9) * 32), 32.0, 32.0)
		counter = randf_range(0.3, 2.0)
