extends Area2D

var level_manager
var camera
var label
var player

var freeze = 0
var adjustment = 0
var skip_turn = false
var step
var distance_to_player

@onready var sprite = $AnimatedSprites
@onready var section_prefab = preload("res://Scenes/Prefabs/firewall_section.tscn")

func _ready():
	level_manager = get_tree().get_first_node_in_group("VirtualLevelManager")
	camera = get_tree().get_first_node_in_group("Camera")
	label = get_tree().get_first_node_in_group("FirewallLabel")
	player = get_tree().get_first_node_in_group("VirtualPlayer")
	create_wall_sprite()
	set_collision_shape()
	step = level_manager.green_firewall_step
	vision_check()

func _process(delta):
	if level_manager.vision:
		update_vision(delta)

func create_wall_sprite():
	var height = level_manager.level_height
	if height < get_viewport_rect().size.y / level_manager.tile_size:
		height = get_viewport_rect().size.y / level_manager.tile_size
	for i in height:
		var section = section_prefab.instantiate()
		sprite.add_child(section)
		section.position = Vector2(16, i * level_manager.tile_size)
		section.animation = str(int(i) % 4)

func set_collision_shape():
	$CollisionShape2D.shape.size = Vector2(30, level_manager.level_height * level_manager.tile_size)
	$CollisionShape2D.position = Vector2(16, 16 + (level_manager.level_height * level_manager.tile_size / 2))

func update_vision(delta):
	label.show()
	label.text = str(distance_to_player)
	var target = Vector2(position.x + 20, camera.position.y - get_viewport_rect().size.y / 4 + 40)
	if position.x < camera.position.x - get_viewport_rect().size.x / 4:
		target.x = camera.position.x - get_viewport_rect().size.x / 4 + 20
	label.global_position = label.global_position.move_toward(target, delta * 300)

# moves wall right when called by level manager
func turn_call():
	if freeze > 0:
		freeze -= 1
		adjustment -= 1
		vision_check()
		return
	if skip_turn:
		skip_turn = false
		vision_check()
		return
	move_wall(step)
	vision_check()

# called when firewall hits player
func _on_area_entered(_area):
	level_manager.call_game_over()

# called to change wall position out of turn call
func move_wall(distance):
	var tween = create_tween()
	tween.tween_property(self, "position",
				Vector2(position.x + distance * level_manager.tile_size, 0),
				1.5 / level_manager.animation_speed
				).set_trans(Tween.TRANS_SINE)

func vision_check():
	if step == 0:
		distance_to_player = "inf"
	else:
		var distance = (((player.position.x - position.x) - (int(player.position.x - position.x) % level_manager.tile_size)) / level_manager.tile_size)
		distance_to_player = snapped(distance, step) / step - 1
