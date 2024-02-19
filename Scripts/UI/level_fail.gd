extends Control

var level_manager
@onready var container = $VBoxContainer

func _ready():
	level_manager = get_tree().get_first_node_in_group("VirtualLevelManager")
	if name == "LevelFail":
		container.get_node("Retry").grab_focus()
	else:
		container.get_node("Resume").grab_focus()

func _on_retry_button_down():
	$/root/Main.retry_level()
	queue_free()

func _on_terminal_button_down():
	level_manager.back_to_terminal()
	queue_free()

func _on_menu_button_down():
	level_manager.call_menu()

func _on_resume_button_down():
	level_manager.paused = false
	queue_free()

func _on_mouse_entered(button_name):
	container.get_node(button_name).grab_focus()
