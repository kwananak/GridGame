extends Area2D

var tile_type = "cannon"
var recharged = 0

@export var cannon_recharge = 1
@export var bullet_speed = 1

@onready var bullet_prefab = preload("res://Scenes/Prefabs/bullet.tscn")
@onready var bullets = $"Bullets"

func turn_call():
	if recharged == cannon_recharge:
		recharged = 0
		await fire_bullet()
	else:
		recharged += 1
	for bullet in bullets.get_children():
		bullet.move_bullet()

func fire_bullet():
	var new_bullet = bullet_prefab.instantiate()
	bullets.add_child(new_bullet)
