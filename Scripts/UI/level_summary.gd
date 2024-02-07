extends Sprite2D

func _ready():
	$Button.grab_focus()

func _on_button_down():
	get_tree().get_first_node_in_group("VirtualLevelManager")._on_button_pressed()
