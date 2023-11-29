extends "res://Scripts/player.gd"

var saved_distance 
var distance_check_pos
var possible_locations = []

func _ready():
	level_manager = get_tree().get_first_node_in_group("VirtualLevelManager")
	enter_level_animation()

func distance_check(distance):
	distance_check_pos = {Vector2.LEFT : true, Vector2.RIGHT : true, Vector2.UP : true, Vector2.DOWN : true}
	saved_distance = distance
	for n in distance_check_pos:
		$DistanceChecker.position = n * (level_manager.tile_size * saved_distance)
		await get_tree().create_timer(0.01).timeout
	for n in distance_check_pos:
		if distance_check_pos[n]:
			var possible_location = $PossibleLocation.duplicate(true)
			add_child(possible_location)
			possible_location.position = n * (level_manager.tile_size * saved_distance)
			possible_locations += [possible_location]
			possible_location.show()

func _on_distance_checker_area_entered(area):
	var occupied = (area.position - position) / (level_manager.tile_size * saved_distance)
	distance_check_pos[occupied] = false

func remove_distance_checkers():
	for n in possible_locations:
		n.queue_free()
	possible_locations = []
