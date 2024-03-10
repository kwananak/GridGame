extends Area2D

var tile_type = "mantis"
var used = true

func _ready():
	await get_tree().create_timer(0.1).timeout
	used = false

func _on_area_entered(area, caller):
	if used:
		return
	if area.is_in_group("VirtualPlayer"):
		get_tree().get_first_node_in_group("VirtualLevelManager").health -= 1
	elif "hit_by_player" in area:
		area.hit_by_player(self)
	elif "tile_type" in area:
		match area.tile_type:
			"beetle":
				return
			_:
				pass
	else:
		return
	used = true
	$Sprite.frame = 1
	var anim = get_node(caller)
	anim.show()
	anim.play()
	$AudioStreamPlayer2D.play()
	await anim.animation_finished
	$Sprite.frame = 2

func _on_tree_exited():
	used = true

func _on_tree_entered():
	await get_tree().create_timer(0.1).timeout
	used = false
