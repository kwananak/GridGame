extends Area2D

var possible = true
var available_action = null
@export var dir : Vector2

func _on_area_entered(area):
	if not "tile_type" in area:
		possible = false
		return
	match area.tile_type:
		"door":
			if area.unlocked:
				return
		"hardened":
			available_action = area
	possible = false

func _on_area_exited(_area):
	possible = true
	available_action = null
