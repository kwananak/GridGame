extends Area2D

@export var dialogue_number : int
@export var text : Array[String]
@export var related_node : Node
@export var text_speed = 5
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

func _ready():
	level_manager = get_tree().get_first_node_in_group("VirtualLevelManager")
	camera = get_tree().get_first_node_in_group("Camera")
	player = get_tree().get_first_node_in_group("VirtualPlayer")
	progress_manager = get_tree().get_first_node_in_group("ProgressManager")
	dialog = progress_manager.dialogs[str(level_manager.level_number)][str(dialogue_number)]["text"]
	highlight_color = progress_manager.dialogs[str(level_manager.level_number)][str(dialogue_number)]["color"]

func _on_area_entered(_area):
	if str(level_manager.level_number) not in progress_manager.log_progress:
		progress_manager.log_progress[str(level_manager.level_number)] = []
	if level_manager.skip_dialogues || str(dialogue_number) in progress_manager.log_progress[str(level_manager.level_number)]:
		queue_free()
		return
	player.get_node("PossibleMoves").hide()
	level_manager.dialogue = self
	if related_node:
		camera_spot = camera.position
		highlight.global_position = related_node.global_position
		highlight.show()
		await create_tween().tween_property(camera, "position", level_manager.out_of_bounds_check(related_node.global_position), 0.5 * camera_speed).finished
	spawn_bubble()

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
	await create_tween().tween_property(bubble, "global_position", camera.position + Vector2(-200, 60), 0.4).finished
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
	label.hide()
	if str(dialogue_number) not in progress_manager.log_progress[str(level_manager.level_number)]:
		progress_manager.log_progress[str(level_manager.level_number)] += [str(dialogue_number)]
	button_sprite.hide()
	bubble.play_backwards()
	await bubble.animation_finished
	bubble.hide()
	await create_tween().tween_property(camera, "position", level_manager.out_of_bounds_check(player.position), 0.4 * camera_speed).finished
	level_manager.dialogue = false
	player.get_node("PossibleMoves").show()
	queue_free()
