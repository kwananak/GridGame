extends Area2D

var tile_type = "program"
var program_slot : String
var program_type : String
var program

signal remove

@onready var name_label = $Sprite2D/PickUp/NameLabel
@onready var info_label = $Sprite2D/PickUp/InfoLabel
@onready var animation_player = $Sprite2D/AnimationPlayer

func _ready():
	for n in get_tree().get_first_node_in_group("ProgressManager").get_node("OwnedPrograms/" + program_slot).get_children():
		if n.name == program_type:
			set_deferred("monitoring", false)
			$Sprite2D.hide()
			return
	program = load("res://Scenes/Programs/" + program_slot + "/" + program_type +  ".tscn").instantiate()
	$Sprite2D.add_child(program)
	program.monitorable = false
	name_label.text = program.type_as_string()
	info_label.text = program_slot.to_upper() + "\n\n" + program.info

func _input(event):
	if Input.is_action_pressed("skip_turn"):
		remove.emit()
		return
	if event is InputEventMouseButton:
		if event.is_pressed() && event.button_index == 1:
			remove.emit()

# calls progress manager to add picked up program to the list
func pick_up(_area):
	get_tree().get_first_node_in_group("VirtualLevelManager").dialogue = true
	$Sprite2D/PickUp.show()
	program.get_node("TileSprite").hide()
	program.get_node("FileSprite").show()
	program.z_index = 91
	program.position = Vector2(-4.5, -3.0)
	program.scale = Vector2(0.45, 0.45)
	animation_player.stop()
	$AudioStreamPlayer.play()
	create_tween().tween_property($Sprite2D, "global_position", global_position + global_position.direction_to(get_tree().get_first_node_in_group("Camera").global_position) * global_position.distance_to(get_tree().get_first_node_in_group("Camera").global_position) / 4, 1)
	await create_tween().tween_property($Sprite2D, "scale", Vector2(7, 7), 1).finished
	$Sprite2D/PickUp/ButtonSprite.show()
	await remove
	program.scale = Vector2.ONE
	program.get_node("FileSprite").hide()
	program.get_node("Sprite2D").show()
	get_tree().get_first_node_in_group("VirtualLevelManager").programs += [[program_slot, program]]
	$Sprite2D.remove_child(program)
	set_deferred("monitorable", false)
	set_deferred("monitoring", false)
	$Sprite2D.hide()
	if has_node("Dialogue"):
		$Dialogue.trigger()
		return
	get_tree().get_first_node_in_group("VirtualLevelManager").dialogue = false
