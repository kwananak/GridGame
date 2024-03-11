extends Area2D

var cannon

func _on_area_entered(area):
	if area.is_in_group("Player"):
		get_tree().get_first_node_in_group("VirtualLevelManager").health -= 1
		if cannon.name.begins_with("Forever"):
			cannon.charge = -1
	if "tile_type" in area:
		match area.tile_type:
			"soap":
				hide()
				while true:
					await get_tree().create_timer(0.01).timeout
					if !area.moving:
						break
				cannon.fire_beam()
