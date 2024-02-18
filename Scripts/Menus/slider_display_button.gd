extends Control

@onready var h_slider = $HBoxContainer/HSlider
@onready var label = $HBoxContainer/Label
@onready var audio_stream_player = $AudioStreamPlayer

func _ready():
	label.text = name
	h_slider.value = 0.5

func _on_h_slider_value_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index(name), linear_to_db(value))

func _on_h_slider_drag_ended(_value_changed):
	if name == "FX":
		audio_stream_player.play()
		await get_tree().create_timer(0.3).timeout
		audio_stream_player.stop()
