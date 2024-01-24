extends Area2D

@export var text : Array[String]
@export var related_node : Node
@export var text_speed = 5
@export var highlight_color = "red"

var animating = true
var writing
var broadcasted = 1
var camera_spot
var camera
var level_manager
var player

@onready var bubble = $Bubble
@onready var button = $Bubble/Button
@onready var label = $Bubble/Label
@onready var highlight = $Highlight
@onready var button_sprite = $Bubble/ButtonSprite

func _ready():
	level_manager = get_tree().get_first_node_in_group("VirtualLevelManager")
	camera = get_tree().get_first_node_in_group("Camera")
	player = get_tree().get_first_node_in_group("VirtualPlayer")

func _on_area_entered(_area):
	player.get_node("PossibleMoves").hide()
	level_manager.dialogue = self
	level_manager.paused = true
	if related_node:
		camera_spot = camera.position
		highlight.global_position = related_node.global_position
		highlight.show()
		await create_tween().tween_property(camera, "position", level_manager.out_of_bounds_check(related_node.global_position), 0.5).finished
	spawn_bubble()

func close():
	if animating:
		return
	if writing:
		writing = false
		return
	if broadcasted < text.size():
		write_bubble(broadcasted)
		broadcasted += 1
		return
	remove_bubble()


func spawn_bubble():
	bubble.global_position = camera.position - Vector2(300, 300)
	bubble.show()
	await create_tween().tween_property(bubble, "global_position", camera.position + Vector2(-300, 20), 0.7).finished
	bubble.get_node("Tail").hide()
	bubble.play()
	await bubble.animation_finished
	write_bubble(0)
	label.show()
	button_sprite.show()
	button.show()
	animating = false

func write_bubble(sentence):
	writing = true
	label.clear()
	var bolded = false
	for i in text[sentence]:
		if i == "$":
			if !bolded:
				label.append_text("[color=" + highlight_color + "]")
				bolded = true
			else:
				label.append_text("[color=white]")
				bolded = false
			continue
		label.append_text(i)
		if writing:
			await get_tree().create_timer(1.0 / text_speed).timeout
	writing = false

func remove_bubble():
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
	player.get_node("PossibleMoves").show()
	queue_free()
