extends Control

var bolded
var log_path = "res://Txts/dialogues.txt"
var progress_manager

@onready var label = $RichTextLabel

func _ready():
	progress_manager = get_tree().get_first_node_in_group("ProgressManager")

func update_log():
	if !visible:
		return
	label.clear()
	for i in progress_manager.log_progress:
		for n in progress_manager.log_progress[i]:
			if !progress_manager.dialogs[i][n]["log"]:
				continue
			for c in progress_manager.dialogs[i][n]["log"]:
				if c == "$":
					if !bolded:
						label.append_text("[color=" + progress_manager.dialogs[i][n]["color"] + "]")
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
