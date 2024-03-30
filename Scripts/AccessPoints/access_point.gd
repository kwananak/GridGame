extends Area2D

var tile_type = "access_point"
var level_manager
var key_ui
var key_ui_initial_position

var vulnerable = false : set = set_vulnerability
var locked = true : set = set_lock

@export var is_locked = true
@export var is_vulnerable= false
@export var strength = 3
@export var access_point_number : int

@onready var anim = $AnimatedSprite2D


func _ready():
	level_manager = get_tree().get_first_node_in_group("VirtualLevelManager")
	key_ui = get_tree().get_first_node_in_group("AccessPointKeyUI")
	key_ui_initial_position = key_ui.position
	locked = is_locked
	if is_vulnerable:
		vulnerable = is_vulnerable

func _process(_delta):
	if level_manager.vision:
		$Label.text = str(strength)

func hit_by_player(hit):
	if vulnerable:
		$hit.play()
		var frame = anim.frame
		anim.animation = "hit"
		anim.frame = frame
		key_ui.frame = 1
		for i in randi_range(4, 6):
			key_ui.position = key_ui_initial_position + Vector2(randi_range(-3, 3), randi_range(-3, 3))
			anim.position = Vector2(randi_range(-3, 3), randi_range(-3, 3))
			await get_tree().create_timer(0.05).timeout
		frame = anim.frame
		key_ui.frame = 0
		anim.animation = "vulnerable"
		anim.frame = frame
		if hit is int:
			strength -= hit
		else:
			strength -= 1
		if strength <= 0:
			key_ui.position = key_ui_initial_position
			for n in get_tree().get_nodes_in_group("VirtualEndTile"):
				if n.global_position == global_position:
					n.on = true
					n.get_node("AnimatedSprite2D").show()
			$destroy.play()
			anim.animation = "destruction"
			await anim.animation_finished
			queue_free()

func set_vulnerability(value):
	if !locked:
		vulnerable = true
		return
	vulnerable = value
	var frame = anim.frame
	if value:
		$on.play()
		anim.animation = "vulnerable"
	else:
		$off.play()
		anim.animation = "invulnerable"
	anim.frame = frame

func set_lock(value):
	if !value:
		vulnerable = true
	locked = value
