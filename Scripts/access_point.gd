extends Area2D

var tile_type = "access_point"
var level_manager

var vulnerable = false : set = set_vulnerability
var locked = true : set = set_lock

@export var is_locked = true
@export var is_vulnerable= false
@export var strength = 3
@export var unlocks : int

@onready var anim = $AnimatedSprite2D

func _ready():
	level_manager = get_tree().get_first_node_in_group("VirtualLevelManager")
	locked = is_locked
	vulnerable = is_vulnerable
	if vulnerable and !locked:
		anim.animation = "vulnerable"
	else:
		anim.animation = "invulnerable"

func _process(_delta):
	if level_manager.vision:
		$Label.text = str(strength)

func hit_by_player(hit):
	if vulnerable:
		var frame = anim.frame
		anim.animation = "hit"
		anim.frame = frame
		await get_tree().create_timer(0.2).timeout
		frame = anim.frame
		anim.animation = "vulnerable"
		anim.frame = frame
		strength -= hit
		if strength <= 0:
			anim.animation = "destruction"
			await anim.animation_finished
			get_tree().get_first_node_in_group("VirtualLevelManager").on_success(unlocks)

func set_vulnerability(value):
	if !locked:
		vulnerable = true
		return
	vulnerable = value
	var frame = anim.frame
	if value:
		anim.animation = "vulnerable"
	else:
		anim.animation = "invulnerable"
	anim.frame = frame

func set_lock(value):
	vulnerable = true
	locked = value
