extends Area2D

@export var keys_needed = 1
@export var key_type = Color.GREEN

func _ready():
	get_node("Label").text = str(keys_needed)
	get_node("Label").set("theme_override_colors/font_color", key_type)

func open_door():
	var lm = $"../../../LevelManager"
	for n in keys_needed:
		lm.keys.erase(key_type)
		lm.set_keys(lm.keys)
	queue_free()
