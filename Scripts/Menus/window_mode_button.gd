extends Control

@onready var option_button = $HBoxContainer/OptionButton as OptionButton

const WINDOW_MODE_ARRAY : Array[String] = [
	"Window",
	"Borderless Window",
	"Fullscreen",
	"Borderless Fullscreen"
]

func _ready():
	add_window_mode_items()
	option_button.item_selected.connect(on_window_mode_selected)

func add_window_mode_items():
	for i in WINDOW_MODE_ARRAY:
		option_button.add_item(i)

func on_window_mode_selected(index : int):
	match index:
		0:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
		1:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)
		2:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
		3:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)
