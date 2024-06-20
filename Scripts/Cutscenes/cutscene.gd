extends Control

@export var cutscene_number : int
@export var text_speed = 20
var writing = false
var data
var written = 0
var fade_done = false
@onready var label = $Sprite2D/Label
@onready var fade = $Fader/AnimationPlayer

func _ready():
	if not FileAccess.file_exists("res://Txts/cutscenes.txt"):
		print("cutscenes.txt doesn't exist")
		return
	var json_string = FileAccess.open("res://Txts/cutscenes.txt", FileAccess.READ).get_line()
	var json = JSON.new()
	var parse_result = json.parse(json_string)
	if not parse_result == OK:
		print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
		return
	data = json.get_data()[str(cutscene_number)]
	fade.play("fade_in")
	create_tween().tween_property($AudioStreamPlayer, "volume_db", 0.0, 2.0)
	await fade.animation_finished
	fade_done = true
	write_text()
	await get_tree().create_timer(0.1).timeout
	$Sprite2D/Button.grab_focus()

func _input(event):
	if event is InputEventMouseButton:
		if event.is_pressed() && event.button_index == 1:
			_on_button_button_down()
	if event.is_action_pressed("select"):
		if event.is_pressed():
			_on_button_button_down()

func _on_button_button_down():
	if !fade_done:
		return
	if writing:
		writing = false
		return
	continue_cutscene()

func continue_cutscene():
	written += 1
	if written >= data.size():
		fade.play("fade_out")
		create_tween().tween_property($AudioStreamPlayer, "volume_db", -80.0, 2.0).set_trans(Tween.TRANS_SINE)
		await fade.animation_finished
		await get_tree().create_timer(0.5).timeout
		$/root/Main.call_level(cutscene_number)
		queue_free()
	else:
		write_text()

func write_text():
	writing = true
	label.text = ""
	for n in data[written]:
		label.text += n
		if writing:
			await get_tree().create_timer(1.0 / text_speed).timeout
	writing = false
