extends Node2D

@export var dialogue_number : String
@export var text : Array[String]
@export var related_node : Node
@export var text_speed = 30
@export var highlight_color = "red"
@export var camera_speed = 1

var animating = true
var writing
var broadcasted = 1
var camera_spot
var camera
var level_manager
var player
var progress_manager
var dialog

@onready var bubble = $Bubble
@onready var button = $Bubble/Button
@onready var label = $Bubble/Label
@onready var highlight = $Highlight
@onready var button_sprite = $Bubble/ButtonSprite
@onready var log_flag = preload("res://Scenes/UI/log_flag.tscn")

func _ready():
	camera = get_tree().get_first_node_in_group("Camera")
	progress_manager = get_tree().get_first_node_in_group("ProgressManager")

func trigger():
	player.get_node("PossibleMoves").hide()
	level_manager.dialogue = self
	if related_node:
		camera_spot = camera.position
		highlight.global_position = related_node.global_position
		highlight.show()
		await create_tween().tween_property(camera, "position", level_manager.out_of_bounds_check(related_node.global_position), 0.5 * camera_speed).finished
	spawn_bubble()
	return

func close():
	if animating:
		return
	if writing:
		writing = false
		return
	if broadcasted < dialog.size():
		write_bubble(broadcasted)
		broadcasted += 1
		return
	remove_bubble()

func spawn_bubble():
	bubble.global_position = camera.position - Vector2(200, 300)
	bubble.show()
	var target_position = camera.position + Vector2(-200, 60)
	var target_speed = 0.4
	if player.global_position.y > camera.global_position.y + 60:
		target_position = camera.global_position + Vector2(-200, -100)
		target_speed = 0.2
	await create_tween().tween_property(bubble, "global_position", target_position, target_speed).finished
	bubble.get_node("Tail").hide()
	bubble.play()
	await bubble.animation_finished
	write_bubble(0)
	label.show()
	button_sprite.show()
	button.show()
	button.grab_focus()
	animating = false

func write_bubble(sentence):
	writing = true
	label.clear()
	var bolded = false
	for i in dialog[sentence]:
		if i == "$":
			if !bolded:
				if !highlight_color:
					highlight_color = "red"
				label.append_text("[color=" + highlight_color + "]")
				bolded = true
			else:
				label.append_text("[color=white]")
				bolded = false
			continue
		label.append_text(i)
		if writing:
			if is_inside_tree():
				await get_tree().create_timer(1.0 / text_speed).timeout
	writing = false

func remove_bubble():
	pass