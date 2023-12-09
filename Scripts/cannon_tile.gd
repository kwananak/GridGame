extends Area2D

var tile_type = "cannon"
var charge = 0
var is_destroyed = false

@export var intial_charge = 0
@export var cannon_recharge = 1
@export var speed = 1 : set = set_speed

@onready var bullet_prefab = preload("res://Scenes/Prefabs/bullet.tscn")
@onready var bullets = $"Bullets"

func _ready():
	charge = intial_charge

# called by level manager to fire abullet if recharge is complete and move fired bullets
func turn_call():
	if !is_destroyed:
		if charge == cannon_recharge:
			charge = 0
			await fire_bullet()
		else:
			charge += 1
	for bullet in bullets.get_children():
		bullet.move_bullet()

# instantiates new bullet as a child
func fire_bullet():
	var new_bullet = bullet_prefab.instantiate()
	new_bullet.speed = speed
	bullets.add_child(new_bullet)

# called by player when hit
func hit_by_player(_strength):
	is_destroyed = true
	$AnimatedSprite2D.frame = 1

func set_speed(value):
	if value < 1:
		speed = 1
	else:
		speed = value
