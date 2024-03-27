extends Area2D

func _ready():
	await get_tree().create_timer(0.1).timeout
	if get_tree().get_first_node_in_group("Player").global_position == global_position:
		$AnimatedSprite2D.play("close")

func _on_animated_sprite_2d_animation_changed():
	match $AnimatedSprite2D.animation:
		"close":
			await $AnimatedSprite2D.frame_changed
			$CloseDoor.play()
		"open":
			$OpenDoor.play()
