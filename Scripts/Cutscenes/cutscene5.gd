extends Control

var counter
var countdown = 7.0
var done = true
var negat_count = 1.0

@onready var explo_prefab = preload("res://Scenes/Prefabs/end_explosion.tscn")
@onready var negative = $Negative
@onready var camera
@onready var fade = $ColorRect/AnimationPlayer

func _ready():
	camera = get_tree().get_first_node_in_group("Camera")
	set_counter()
	fade.play("fade_in")
	await fade.animation_finished
	done = false

func _process(delta):
	if done:
		return
	countdown -= delta
	if countdown < 0.0:
		fade.play("fade_out")
		done = true
		animation_finished()
	counter -= delta
	negat_count -= delta
	if counter < 0.0:
		var explo = explo_prefab.instantiate()
		add_child(explo)
		explo.rotation_degrees = randf_range(0.0, 360.0)
		explo.position += Vector2(randf_range(30.0, 150.0), 0).rotated(explo.rotation)
		explo.show()
		explo.play()
		set_counter()
		if negat_count < 0:
			if negative.visible:
				negative.hide()
			else:
				negative.show()

func set_counter():
	counter = randf_range(0.05, 0.2)

func animation_finished():
	await fade.animation_finished
	$"1st".show()
	fade.play("fade_in")
	await create_tween().tween_property(camera, "zoom", camera.zoom * 1.2, 4.0).finished
	$"2nd".show()
	camera.zoom /= 1.2
	await create_tween().tween_property(camera, "zoom", camera.zoom * 1.2, 4.0).finished
	$"3rd".show()
	camera.zoom /= 1.2
	await create_tween().tween_property(camera, "zoom", camera.zoom * 1.2, 4.0).finished
