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

@onready var beam_prefab = preload("res://Scenes/Prefabs/beam.tscn")
@onready var label = $Label

func _ready():
	charge = intial_charge
	await get_tree().create_timer(0.2).timeout
	level_manager = get_tree().get_first_node_in_group("VirtualLevelManager")
	if level_manager.vision:
		label.rotation = -rotation
		label.global_position += Vector2(-16, -16)
		label.text = str(cannon_recharge - charge) + "  " + str(duration)
		label.show()

# called by level manager to fire a beam if recharge is complete
func turn_call():
	for n in $Beam.get_children():
		n.queue_free()
	if !is_destroyed:
		if charge == cannon_recharge:
			if firing_for == duration:
				$AnimatedSprite2D.animation = "default"
				charge = 0
				firing_for = 0
			else:
				$AnimatedSprite2D.animation = "firing"
				firing_for += 1
				fire_beam()
		else:
			charge += 1
		label.text = str(cannon_recharge - charge) + "  " + str(duration)
	else:
		label.text = ""
		remove_from_group("EndTurn")

# instantiates new beam as a child
func fire_beam():
	for i in distance:
		var beam_section = beam_prefab.instantiate()
		$Beam.add_child(beam_section)
		beam_section.position = Vector2.RIGHT * level_manager.tile_size * (i + 1)

func hit_by_player(_strength):
	is_destroyed = true
	$AnimatedSprite2D.animation = "default"
	$AnimatedSprite2D.frame = 1

func set_duration(value):
	if value < 1:
		duration = 1
	else:
		duration = value
