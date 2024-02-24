extends Control

var bolded
var log_path = "res://Txts/dialogues.txt"

@onready var label = $RichTextLabel

func update_log():
	if !visible:
		return
	label.clear()
	var log_file = FileAccess.open(log_path, FileAccess.READ)
	var json_string = log_file.get_line()
	log_file.close()
	var json = JSON.new()
	var parse_result = json.parse(json_string)
	if not parse_result == OK:
		print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
		return
	var data = json.get_data()
	for i in int(get_tree().get_first_node_in_group("ProgressManager").log_save_point):
		if not str(i+1) in data:
			continue
		if !data[str(i+1)]["log"]:
			continue
		for n in data[str(i+1)]["text"]:
			for c in n:
				if c == "$":
					if !bolded:
						label.append_text("[color=" + data[str(i+1)]["color"] + "]")
						bolded = true
					else:
						label.append_text("[color=white]")
						bolded = false
				else:
					label.append_text(c)
			label.append_text("\n")
		label.append_text("\n")

func _on_rich_text_label_focus_entered():
	$Frame.show()

func _on_rich_text_label_focus_exited():
	$Frame.hide()

func _on_mouse_entered():
	$RichTextLabel.grab_focus()
