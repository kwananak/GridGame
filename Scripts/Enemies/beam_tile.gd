extends Area2D

var tile_type = "cannon"
var charge = 0
var firing_for = 0
var is_destroyed = false
var level_manager

@export var intial_charge = 0
@export var cannon_recharge = 1
@export var duration = 1 : set = set_duration
@export var distance = 1
@export var extreme = false

@onready var beam_prefab = preload("res://Scenes/Prefabs/beam.tscn")
@onready var label = $Label
@onready var ray = $RayCast2D
@onready var sprite = $Sprite

func _ready():
	charge = intial_charge
	await get_tree().create_timer(0.2).timeout
	level_manager = get_tree().get_first_node_in_group("VirtualLevelManager")
	if level_manager.vision:
		label.rotation = -rotation
		label.global_position += Vector2(-16, -16)
		label.text = str(cannon_recharge - charge) + "  " + str(duration)
		label.show()
	if cannon_recharge == 0:
		sprite.frame = 2
		fire_beam()

# called by level manager to fire a beam if recharge is complete
func turn_call():
	for n in $Beam.get_children():
		n.queue_free()
	if !is_destroyed:
		if charge == cannon_recharge:
			if firing_for == duration && cannon_recharge != 0:
				sprite.frame = 0
				charge = 0
				firing_for = 0
			else:
				sprite.frame = 2
				firing_for += 1
				fire_beam()
		else:
			if cannon_recharge - charge == 1:
				sprite.frame = 1
			charge += 1
		label.text = str(cannon_recharge - charge) + "  " + str(duration)
	else:
		label.text = ""
		remove_from_group("EndTurn")

# instantiates new beam as a child
func fire_beam():
	for n in $Beam.get_children():
		n.queue_free()
	if distance == 0:
		var i = 0
		while true:
			ray.position = Vector2(i * level_manager.tile_size, 0)
			ray.force_raycast_update()
			if ray.get_collider():
				if "tile_type" in ray.get_collider():
					match ray.get_collider().tile_type:
						"hole", "chip", "key":
							pass
						"enemy":
							ray.get_collider().hit_by_player(3)
							break
						_:
							break
				else:
					break
			if i > 64:
				break
			else:
				var beam_section = beam_prefab.instantiate()
				beam_section.cannon = self
				$Beam.call_deferred("add_child", beam_section)
				if cannon_recharge == 0:
					if extreme:
						beam_section.get_node("AnimatedSprite2D").set_deferred("animation", "extreme")
					else:
						beam_section.get_node("AnimatedSprite2D").set_deferred("animation", "forever")
				beam_section.position = Vector2.RIGHT * level_manager.tile_size * (i + 1)
				i += 1
	else:
		for i in distance:
			var beam_section = beam_prefab.instantiate()
			beam_section.cannon = self
			$Beam.add_child(beam_section)
			beam_section.position = Vector2.RIGHT * level_manager.tile_size * (i + 1)

func hit_by_player(_strength):
	if is_destroyed:
		return
	sprite.frame = 3
	if get_tree().get_first_node_in_group("FramedChecker").check(position):
		$Audio.play()
	for n in $Beam.get_children():
		n.queue_free()
	is_destroyed = true

func set_duration(value):
	if value < 1:
		duration = 1
	else:
		duration = value
