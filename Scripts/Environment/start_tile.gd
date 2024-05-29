extends Area2D

func _on_animated_sprite_2d_animation_changed():
	match $AnimatedSprite2D.animation:
		"close":
			await $AnimatedSprite2D.frame_changed
			$CloseDoor.play()
		"open":
			$OpenDoor.play()
