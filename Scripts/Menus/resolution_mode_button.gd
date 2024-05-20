extends Control

@onready var option_button = $HBoxContainer/OptionButton

const RESOLUTION_DICT : Dictionary = {
	"854 * 480" = Vector2i(854, 480),
	"1280 * 720" = Vector2i(1280, 720),
	"1600 * 900" = Vector2i(1600, 900),
	"1920 * 1080" = Vector2i(1920, 1080),
	"2560 * 1440" = Vector2i(2560, 1440),
	"3840 * 2160" = Vector2i(3840, 2160)
}

func _ready():
	add_resolution_items()
	option_button.item_selected.connect(on_resolution_selected)

func add_resolution_items():
	for i in RESOLUTION_DICT:
		option_button.add_item(i)

func on_resolution_selected(index : int):
	DisplayServer.window_set_size(RESOLUTION_DICT.values()[index])

