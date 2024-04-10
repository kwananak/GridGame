extends Area2D

var tile_type = "beam"
var cannon

func _on_area_entered(area):
	if "tile_type" in area:
		match area.tile_type:
			"soap":
				hide()
				while true:
					await get_tree().create_timer(0.01).timeout
					if !area.moving:
						break
				cannon.fire_beam()
			"enemy":
				cannon.fire_beam()
				if cannon.name.begins_with("Forever"):
					cannon.charge = -1
	if area.is_in_group("Beam"):
		$AnimatedSprite2D.play("extreme")
	if area.is_in_group("Player"):
		var lev_man = get_tree().get_first_node_in_group("VirtualLevelManager")
		lev_man.health -= 1
		if cannon.name.begins_with("Forever"):
			cannon.charge = -1
		if cannon.name.begins_with("Extreme"):
			lev_man.call_game_over()
