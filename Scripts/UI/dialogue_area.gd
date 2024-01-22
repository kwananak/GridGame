extends Area2D

@export var text : Array[String]
@export var related_node : Node

var camera
var level_manager
var broadcasted = 1
var camera_spot

@onready var bubble = $Bubble
@onready var button = $Bubble/Button
@onready var label = $Bubble/Label
@onready var highlight = $Highlight
@onready var button_sprite = $Bubble/ButtonSprite

func _ready():
	level_manager = get_tree().get_first_node_in_group("VirtualLevelManager")
	camera = get_tree().get_first_node_in_group("Camera")

func _on_area_entered(_area):
	level_manager.dialogue = self
	level_manager.paused = true
	if related_node:
		camera_spot = camera.position
		highlight.global_position = related_node.global_position
		highlight.show()
		await create_tween().tween_property(camera, "position", related_node.global_position, 0.5).finished
	spawn_bubble()

func close():
	if broadcasted < text.size():
		label.text  = text[broadcasted]
		broadcasted += 1
		return
	label.hide()
	button_sprite.hide()
	bubble.play_backwards()
	await bubble.animation_finished
	bubble.hide()
	if related_node:
		highlight.hide()
		await create_tween().tween_property(camera, "position", camera_spot, 0.4).finished
	level_manager.dialogue = false
	level_manager.paused = false
	queue_free()

func spawn_bubble():
	bubble.global_position = camera.position - Vector2(300, 300)
	bubble.show()
	await create_tween().tween_property(bubble, "global_position", camera.position + Vector2(-300, 20), 0.7).finished
	bubble.get_node("Tail").hide()
	bubble.play()
	await bubble.animation_finished
	label.text  = text[0]
	label.show()
	button_sprite.show()
	button.show()
