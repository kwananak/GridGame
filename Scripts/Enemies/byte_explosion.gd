extends AnimatedSprite2D

func _ready():
	play()
	await animation_finished
	queue_free()
