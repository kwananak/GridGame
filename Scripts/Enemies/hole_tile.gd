extends Area2D


var tile_type = "hole"
var charge = 0
var opened_for = 0
var is_destroyed = false
var level_manager

@export var opened = true
@export var intial_charge = 0
@export var cannon_recharge = 0
@export var duration = 1 : set = set_duration
@export var distance = 1

@onready var label = $Label
@onready var sprite = $AnimatedSprite2D

func _ready():
	charge = intial_charge
	await get_tree().create_timer(0.2).timeout
	level_manager = get_tree().get_first_node_in_group("VirtualLevelManager")
	if level_manager.vision:
		label.rotation = -rotation
		label.global_position += Vector2(-16, -16)
		label.text = str(cannon_recharge - charge) + "  " + str(duration - opened_for)
		label.show()
	if cannon_recharge != 0:
		opened = false
		$AnimatedSprite2D.show()

# called by level manager to fire a beam if recharge is complete
func turn_call():
	if !is_destroyed:
		if charge == cannon_recharge:
			if !opened:
				sprite.animation = "open"
				sprite.play()
				opened = true
			if has_overlapping_areas():
				if !level_manager.floating:
					for n in get_overlapping_areas():
						if n.is_in_group("VirtualPlayer"):
							level_manager.call_game_over()
							n.return_animation()
			if cannon_recharge == 0:
				return
			if opened_for == duration:
				sprite.animation = "close"
				sprite.play()
				opened = false
				charge = 0
				opened_for = 0
			else:
				opened_for += 1
		else:
			charge += 1
		label.text = str(cannon_recharge - charge) + "  " + str(duration - opened_for)
	else:
		label.text = ""
		remove_from_group("EndTurn")

func hit_by_wall(area):
	if cannon_recharge == 0:
		return
	if area.name == "Firewall":
		is_destroyed = true

func set_duration(value):
	if value < 1:
		duration = 1
	else:
		duration = value
