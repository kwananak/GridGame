extends Control

@onready var h_slider = $HBoxContainer/HSlider
@onready var label = $HBoxContainer/Label

func _ready():
	label.text = name
	h_slider.value = AudioServer.get_bus_volume_db(AudioServer.get_bus_index(name)) + 80

func _on_h_slider_value_changed(value):
	if value <= 0:
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index(name), -80)
	else:
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index(name), (h_slider.value - 80) / 4)
