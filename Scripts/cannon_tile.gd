extends Area2D

var tile_type = "cannon"
var charge = 0
var is_destroyed = false

@export var intial_charge = 0
@export var cannon_recharge = 1
@export var speed = 1 : set = set_speed

@onready var bullet_prefab = preload("res://Scenes/Prefabs/bullet.tscn")
@onready var bullets = $Bullets
@onready var label = $Label

func _ready():
	charge = intial_charge
	await get_tree().create_timer(0.2).timeout
	if get_tree().get_first_node_in_group("VirtualLevelManager").vision:
		label.rotation = -rotation
		label.global_position += Vector2(-16, -16)
		label.text = str(cannon_recharge - charge) + "  " + str(speed)
		label.show()

# called by level manager to fire abullet if recharge is complete and move fired bullets
func turn_call():
	var text_bit
	if !is_destroyed:
		if charge == cannon_recharge:
			charge = 0
			await fire_bullet()
		else:
			charge += 1
		text_bit = str(cannon_recharge - charge)
	else:
		if bullets.get_child_count() == 0:
			remove_from_group("EndTurn")
		text_bit = "  "
	for bullet in bullets.get_children():
		bullet.move_bullet()
	label.text = text_bit + "  " + str(speed)

# instantiates new bullet as a child
func fire_bullet():
	var new_bullet = bullet_prefab.instantiate()
	bullets.add_child(new_bullet)
	new_bullet.speed = speed

# called by player when hit
func hit_by_player(_strength):
	is_destroyed = true
	$AnimatedSprite2D.frame = 1

func set_speed(value):
	if value < 1:
		speed = 1
	else:
		speed = value
