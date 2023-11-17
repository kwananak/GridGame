extends Area2D

var tile_type = "cannon"
var charge = 0
var is_destroyed = false

@export var cannon_recharge = 1
@export var bullet_speed = 1

@onready var bullet_prefab = preload("res://Scenes/Prefabs/bullet.tscn")
@onready var bullets = $"Bullets"

func turn_call():
	if !is_destroyed:
		if charge == cannon_recharge:
			charge = 0
			await fire_bullet()
		else:
			charge += 1
	for bullet in bullets.get_children():
		bullet.move_bullet()

func fire_bullet():
	var new_bullet = bullet_prefab.instantiate()
	bullets.add_child(new_bullet)

func hit_by_player():
	is_destroyed = true
	$AnimatedSprite2D.frame = 1
