extends Area2D

var tile_type = "beam"
var cannon

func _on_area_entered(area):
	if "tile_type" in area:
		match area.tile_type:
			"soap":
				var trigger = false
				for n in cannon.get_node("Beam").get_children():
					if n == self:
						trigger = true
					if trigger:
						n.hide()
				while has_overlapping_areas():
					await get_tree().create_timer(0.1).timeout
					if !area.moving:
						break
				cannon.fire_beam()
			"enemy":
				cannon.fire_beam()
				if cannon.name.begins_with("Forever"):
					cannon.charge = -1
			"beam":
				$AnimatedSprite2D.play("extreme")
	elif area.is_in_group("Player"):
		var lev_man = get_tree().get_first_node_in_group("VirtualLevelManager")
		lev_man.health -= 1
		if cannon.name.begins_with("Forever"):
			cannon.charge = -1
		if cannon.name.begins_with("Extreme"):
			lev_man.call_game_over()
