extends Node2D

var level_manager
var main
var downed = false

# Called when the node enters the scene tree for the first time.
func _ready():
	show()
	main = $/root/Main
	level_manager = get_tree().get_first_node_in_group("VirtualLevelManager")
	if main.real_scene != null:
		$InfoUI.text = main.get_level_name(main.real_scene.get_node("RealLevelManager").level_number) + "\n"
	$InfoUI.text += main.get_level_name(level_manager.level_number)

func toggle_ui(try_hide):
	if downed == null:
		return
	if downed != try_hide:
		downed = null
		var going = Vector2(0, 200)
		if !try_hide:
			going = -going
		for n in get_children():
			match n.name:
				"LevelSummary", "Vignette":
					continue
				_:
					create_tween().tween_property(n, "position", n.position + going, 0.5)
		await get_tree().create_timer(0.5).timeout
		downed = try_hide

func show_ui():
	if !downed:
		return
	for n in get_children():
		match n.name:
			"LevelSummary", "Vignette":
				continue
			_:
				create_tween().tween_property(n, "position", n.position - Vector2(0, 200), 1.0)
	downed = false
