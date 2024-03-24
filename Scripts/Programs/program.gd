extends Area2D

var type : String
var progress_manager
var level_manager
var player
var recharge = 0
var duration = 0
var focus = false : set = set_focus
var info : String
var mouse_tip
var active = false
var usable = true
var runed = false
var mouse_on = false

func _ready():
	mouse_tip = get_tree().get_first_node_in_group("MouseToolTip")
	player = get_tree().get_first_node_in_group("VirtualPlayer")
	progress_manager = get_tree().get_first_node_in_group("ProgressManager")
	visibility_changed.connect(vis_changed)

func loaded():
	level_manager = get_tree().get_first_node_in_group("VirtualLevelManager")
	player = get_tree().get_first_node_in_group("VirtualPlayer")
	$Sprite2D.hide()
	$TileSprite.hide()
	$FileSprite.hide()
	$LoadedSprite.show()
	if active:
		player.moving_signal.connect(available)
		$LoadedSprite/Button.show()

func picked_up(slot):
	set_deferred("monitorable", false)
	hide()
	get_tree().get_first_node_in_group("VirtualLevelManager").programs += [[slot, self]]

func action():
	pass

func recharging():
	pass

func end_turn():
	pass

func cancel_action():
	pass

func confirm():
	pass

func _on_mouse_entered():
	if get_parent().get_parent().name == "Loadout":
		if "info" in get_parent().get_parent():
			get_parent().get_parent().info.text = get_parent().name + "\n" + name + "\n" + info
	mouse_on = true

func _on_mouse_exited():
	mouse_on = false

func set_focus(value):
	focus = value
	if focus:
		z_index = 90
		create_tween().tween_property(self, "scale", Vector2(2.0, 2.0), 0.2)
		create_tween().tween_property(self, "position", position - Vector2(0, 8), 0.2)
		create_tween().tween_property($LoadedSprite/Button, "scale", Vector2(1.5, 1.5), 0.2)
		create_tween().tween_property($LoadedSprite/Button, "position", $LoadedSprite/Button.position - Vector2(0, 4), 0.2)
		$LoadedSprite/Button.frame = 1
	else:
		create_tween().tween_property(self, "scale", Vector2.ONE, 0.2)
		create_tween().tween_property(self, "position", position + Vector2(0, 8), 0.2)
		create_tween().tween_property($LoadedSprite/Button, "scale", Vector2.ONE, 0.2)
		create_tween().tween_property($LoadedSprite/Button, "position", $LoadedSprite/Button.position + Vector2(0, 4), 0.2)
		$LoadedSprite/Button.frame = 0
		z_index = 0

func available(value):
	if value:
		$Focus.show()
	else:
		await get_tree().create_timer(0.02).timeout
		if !player.moving:
			$Focus.hide()
			if !focus:
				$LoadedSprite/Button.frame = 0

func vis_changed():
	var ui = get_tree().get_first_node_in_group("UI")
	if ui:
		set_deferred("monitorable", ui.visible)
