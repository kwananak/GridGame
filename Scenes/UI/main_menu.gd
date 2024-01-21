class_name MainMenu
extends Control

@onready var main = preload("res://Scenes/Main.tscn") as PackedScene
# @onready var options = preload("res://Scenes/Options.tscn") as PackedScene

func _on_new_game_button_down():
	get_tree().change_scene_to_packed(main)

func _on_load_game_button_down():
	pass

func _on_options_button_down():
	pass # get_tree().change_scene_to_packed(options)

func _on_quit_button_down():
	get_tree().quit()
