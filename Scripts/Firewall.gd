extends Area2D

var adjustment = 0
var skip_turn = false
var distance_to_player
var freeze = 0

var level_manager
var camera
var label
var player

@onready var sprite = $AnimatedSprites
@onready var section_prefab = preload("res://Scenes/Prefabs/firewall_section.tscn")

func _ready():
	level_manager = get_tree().get_first_node_in_group("VirtualLevelManager")
	camera = get_tree().get_first_node_in_group("Camera")
	label = get_tree().get_first_node_in_group("FirewallLabel")
	player = get_tree().get_first_node_in_group("VirtualPlayer")
	await get_tree().create_timer(0.02).timeout
	create_wall()
	$CollisionShape2D.shape.extents = Vector2(30, level_manager.level_height)
	$CollisionShape2D.position = Vector2(0, level_manager.level_height / 2)
	turn_call()

func _process(delta):
	if level_manager.vision:
		update_vision(delta)

func create_wall():
	var wall_length = (level_manager.level_height - (level_manager.level_height % level_manager.tile_size)) / level_manager.tile_size 
	for i in wall_length:
		var section = section_prefab.instantiate()
		$AnimatedSprites.add_child(section)
		section.position = Vector2(16, i * level_manager.tile_size)
		section.animation = str(i % 4)

func update_vision(delta):
	label.show()
	label.text = str(distance_to_player)
	var target = Vector2(position.x + 20, camera.position.y - get_viewport_rect().size.y / 4 + 40)
	if position.x < camera.position.x - get_viewport_rect().size.x / 4:
		target.x = camera.position.x - get_viewport_rect().size.x / 4 + 20
	label.global_position = label.global_position.move_toward(target, delta * 200)

# moves wall right when called by level manager
func turn_call():
	if freeze > 0:
		freeze -= 1
		adjustment -= 1
		distance_to_player = (((player.position.x - position.x) / level_manager.tile_size) / level_manager.firewall_step) - 1
		return
	if skip_turn:
		skip_turn = false
		distance_to_player = (((player.position.x - position.x) / level_manager.tile_size) / level_manager.firewall_step) - 1
		return
	if level_manager.turn % level_manager.firewall_speed == 0:
		var old_pos = position
		position = Vector2(level_manager.turn / level_manager.firewall_speed - 1 + adjustment, 0.0) * level_manager.tile_size * level_manager.firewall_step
		sprite.global_position = old_pos
		animate_wall()
	distance_to_player = (((player.position.x - position.x) / level_manager.tile_size) / level_manager.firewall_step) - 1

# makes visuals catch up with actual position
func animate_wall():
	var tween = create_tween()
	tween.tween_property($AnimatedSprites, "position",
			Vector2.ZERO, 
			1.5 / (level_manager.animation_speed * 2)
			).set_trans(Tween.TRANS_SINE)
	await tween.finished

# called when firewall hits player
func _on_area_entered(_area):
	level_manager.call_game_over()

# called to change wall position out of turn call
func move_wall(distance):
	adjustment += distance
	var tween = create_tween()
	tween.tween_property(self, "position",
				Vector2(level_manager.turn / level_manager.firewall_speed - 1 + adjustment, 0.0)
						* level_manager.tile_size * level_manager.firewall_step, 
				1.5 / (level_manager.animation_speed * 2)
				).set_trans(Tween.TRANS_SINE)
	await tween.finished
