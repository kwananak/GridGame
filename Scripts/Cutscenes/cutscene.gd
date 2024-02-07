extends Control

@export var cutscene_number : int
var writing = false
var data
var written = 0
@onready var label = $Sprite2D/Label

func _ready():
	$Sprite2D/Button.grab_focus()
	if not FileAccess.file_exists("res://cutscenes.txt"):
		$/root/Main.disable_continue()
		return
	var json_string = FileAccess.open("res://cutscenes.txt", FileAccess.READ).get_line()
	var json = JSON.new()
	var parse_result = json.parse(json_string)
	if not parse_result == OK:
		print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
		return
	data = json.get_data()[str(cutscene_number)]
	write_text()


func _on_button_button_down():
	if writing:
		writing = false
		return
	continue_cutscene()

func continue_cutscene():
	written += 1
	if written >= data.size():
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
			await get_tree().create_timer(0.1).timeout
	writing = false
