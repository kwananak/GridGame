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
	if level_manager.skip_dialogues:
		queue_free()
		return
	player.get_node("PossibleMoves").hide()
	level_manager.dialogue = self
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
	await create_tween().tween_property(bubble, "global_position", camera.position + Vector2(-300, 12), 0.2).finished
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
	for i in text[sentence]:
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
	label.hide()
	button_sprite.hide()
	bubble.play_backwards()
	await bubble.animation_finished
	bubble.hide()
	await create_tween().tween_property(camera, "position", level_manager.out_of_bounds_check(player.position), 0.4).finished
	level_manager.dialogue = false
	player.get_node("PossibleMoves").show()
	queue_free()
