extends Label

@export var slot : String

func _ready():
	get_tree().get_first_node_in_group("Settings").joypad_config_signal.connect(update_label)
	update_label(false)

func update_label(_joypad):
	if is_inside_tree():
		text = get_tree().get_first_node_in_group(slot + "SettingButton").button.text
		if text.begins_with("Button"):
			text = text.substr(7, -1)

func _on_tree_entered():
	await get_tree().create_timer(0.05).timeout
	update_label(false)
