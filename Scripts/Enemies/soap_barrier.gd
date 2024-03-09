extends Area2D

var tile_type = "soap"
var moved = false
var target

@onready var ray = $RayCast2D

func check_move(player_position):
	ray.target_position = position - player_position
	ray.force_raycast_update()
	if ray.get_collider():
		return false
	target = ray.target_position
	return true

func _on_area_entered(area):
	$AudioStreamPlayer2D.play()
	if area is Vector2:
		create_tween().tween_property(self, "position", position + area, 1.5/get_tree().get_first_node_in_group("VirtualLevelManager").animation_speed).set_trans(Tween.TRANS_SINE)
		$AnimatedSprite2D.frame = 1
		moved = true
		return
	if area.is_in_group("Player"):
		ray.target_position = target
		while true:
			ray.force_raycast_update()
			if ray.get_collider():
				break
			var old_pos = global_position
			position += target
			$AnimatedSprite2D.global_position = old_pos
			await create_tween().tween_property($AnimatedSprite2D, "position", Vector2.ZERO, 1.5 /get_tree().get_first_node_in_group("VirtualLevelManager").animation_speed).set_trans(Tween.TRANS_SINE).finished
		$AnimatedSprite2D.frame = 1
		moved = true
