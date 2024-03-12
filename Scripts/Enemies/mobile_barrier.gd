extends Area2D

var tile_type = "mobile"
var moved = false
var target

@onready var ray = $RayCast2D
@onready var sprite = $AnimatedSprite2D
@onready var audio = $AudioStreamPlayer2D

func check_move(player_position):
	ray.target_position = position - player_position
	ray.force_raycast_update()
	if ray.get_collider():
		return false
	target = ray.target_position
	return true

func _on_area_entered(area):
	moved = true
	if area.is_in_group("Player"):
		audio.play()
		var old_pos = global_position
		position += target
		sprite.global_position = old_pos
		await create_tween().tween_property(sprite, "position", Vector2.ZERO, 1.5/get_tree().get_first_node_in_group("VirtualLevelManager").animation_speed).set_trans(Tween.TRANS_SINE).finished
	sprite.frame = 1

func grapple_move(direction):
	moved = true
	audio.play()
	var old_pos = global_position
	position += direction
	sprite.global_position = old_pos
	await create_tween().tween_property(sprite, "position", Vector2.ZERO, 1.5/get_tree().get_first_node_in_group("VirtualLevelManager").animation_speed).set_trans(Tween.TRANS_SINE).finished
	sprite.frame = 1
