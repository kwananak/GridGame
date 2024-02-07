extends Sprite2D

func _ready():
	$Control/Retry.grab_focus()

func _on_retry_button_down():
	$/root/Main.retry_level()
	queue_free()

func _on_quit_button_down():
	get_tree().get_first_node_in_group("VirtualLevelManager")._on_button_pressed()
	queue_free()
