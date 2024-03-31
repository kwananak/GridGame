extends "res://Scripts/Environment/door_tile.gd"

@export var door_number : int

var progress_manager
var on = false

func _ready():
	level_manager = get_tree().get_first_node_in_group("RealLevelManager")
	progress_manager = get_tree().get_first_node_in_group("ProgressManager")
	animated_sprite_2d.animation_changed.connect(door_sound)
	update_door()

func update_door():
	for i in progress_manager.doors:
		if i == str(door_number):
			animated_sprite_2d.frame = 1
			unlocked = true
			for n in get_tree().get_nodes_in_group("EndTile"):
				if n.global_position == global_position:
					await get_tree().create_timer(0.01).timeout
					if get_tree().get_first_node_in_group("RealPlayer").global_position - Vector2(0, 16) == global_position:
						animated_sprite_2d.play("close")
						continue
					else:
						on = true
					await get_tree().create_timer(0.15).timeout
					n.on = true

func _on_body_entered(body):
	if body.global_position && on:
		animated_sprite_2d.play("open")

func _on_body_exited(_body):
	on = true
