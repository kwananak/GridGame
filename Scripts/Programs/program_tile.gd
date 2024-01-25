extends Area2D

var tile_type = "program"
var program_slot : String
var program_type : String
var program

@onready var name_label = $AnimatedSprite2D/NameLabel
@onready var info_label = $AnimatedSprite2D/InfoLabel
@onready var animation_player = $AnimatedSprite2D/AnimationPlayer

func _ready():
	program = load("res://Scenes/Programs/" + program_slot + "/" + program_type +  ".tscn").instantiate()
	$AnimatedSprite2D.add_child(program)
	name_label.text = program_type.to_upper()
	info_label.text = program_slot.to_upper() + "\n\n" + program.info
	program.position = Vector2(-13.5, -9.5)
	program.scale = Vector2(1.25, 1.25)

# calls progress manager to add picked up program to the list
func pick_up(_area):
	program.scale = Vector2.ONE
	program.set_deferred("monitorable", false)
	get_tree().get_first_node_in_group("VirtualLevelManager").programs += [[program_slot, program]]
	get_tree().get_first_node_in_group("MouseToolTip").hide()
	$AnimatedSprite2D.remove_child(program)
	queue_free()

func _on_mouse_entered():
	animation_player.pause()
	z_index = 97
	create_tween().tween_property(self, "scale", Vector2(5, 5), 0.2)

func _on_mouse_exited():
	animation_player.play()
	z_index = 30
	create_tween().tween_property(self, "scale", Vector2(1, 1), 0.2)
