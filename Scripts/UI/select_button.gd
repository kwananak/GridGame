extends Sprite2D

@export var digital = false

var flip_flop = true
var counter = 1.5

func _ready():
	texture = texture.duplicate()
	if digital:
		texture.region.position += Vector2(32, 0)
		$Label.add_theme_color_override("font_color", Color("5fcde4"))
	get_tree().get_first_node_in_group("Settings").joypad_config_signal.connect(update_label)
	update_label(false)

func update_label(_joypad):
	if is_inside_tree():
		$Label.text = get_tree().get_first_node_in_group("SelectButton").button.text

func _on_tree_entered():
	await get_tree().create_timer(0.05).timeout
	update_label(false)

func _process(delta):
	counter -= delta
	if counter <= 0:
		if flip_flop:
			texture.region.position -= Vector2(0, 1)
			$Label.position += Vector2(0, 1)
			counter = 0.5
			flip_flop = false
		else:
			texture.region.position += Vector2(0, 1)
			$Label.position -= Vector2(0, 1)
			counter = 1.5
			flip_flop = true
