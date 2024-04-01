extends Sprite2D


# Called when the node enters the scene tree for the first time.
func _ready():
	position.y += 100
	position.x -= get_viewport_rect().size.x / 4
	show()
	await create_tween().tween_property(self, "position", Vector2(position.x + 120, position.y), 0.4).finished
	await get_tree().create_timer(1.0).timeout
	await create_tween().tween_property(self, "position", Vector2(position.x - 120, position.y), 0.4).finished
	queue_free()
