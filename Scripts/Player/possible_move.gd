extends Area2D

var possible = false : set = set_possible
var available_action = null : set = set_available_action
var player
var moused = false
var shootable = false
var level_manager

@export var dir : Vector2
@onready var sprite = $AnimatedSprite2D
@onready var teleport_sprite = $TeleportSprite

func _ready():
	player = get_tree().get_first_node_in_group("Player")
	level_manager = get_tree().get_first_node_in_group("VirtualLevelManager")
	teleport_sprite.rotation = -rotation
	level_manager.pause_trigger.connect(pause_handling)

func pause_handling(paused):
	if paused:
		hide()
	else:
		set_possible(possible)

# checks collision and adjusts vars accordingly
func check_collision(collision):
	possible = false
	if "tile_type" in collision:
		match collision.tile_type:
			"access_point":
				if player.teleport:
					return
				if collision.vulnerable:
					available_action = collision
					return
			"chip", "key":
				if player.waiting_for_action:
					match player.waiting_for_action.type:
						"QuantumGrapple":
							available_action = collision
							return
				possible = true
				return
			"door":
				if collision.unlocked:
					possible = true
					return
			"hardened":
				shootable = true
				available_action = collision
				return
			"cannon", "enemy":
				if player.teleport || !collision.is_destroyed:
					available_action = collision
					return
			"hole":
				if player.waiting_for_action:
					match player.waiting_for_action.type:
						"QuantumGrapple" , "1-0-1Shotgun", "Salty":
							possible = true
							return
				if !collision.opened || get_tree().get_first_node_in_group("VirtualLevelManager").floating:
					possible = true
					return
			"mobile", "soap":
				if player.waiting_for_action:
					if player.waiting_for_action.type == "QuantumGrapple" || player.teleport:
						available_action = collision
						return
				if !collision.moved:
					if collision.check_move(player.global_position):
						available_action = collision
						return
			"beetle":
				if player.teleport:
					available_action = collision
				shootable = true
				return
			"mantis":
				if player.teleport:
					available_action = collision
				return
	available_action = null

func reset():
	hide()
	available_action = null
	possible = false
	shootable = false
	position = Vector2.ZERO

func set_possible(value):
	possible = value
	if value:
		if player.teleport:
			sprite.hide()
			teleport_sprite.show()
		else:
			teleport_sprite.hide()
			sprite.animation = "move"
			sprite.show()
		show()

func set_available_action(value):
	available_action = value
	if available_action == null:
		hide()
		return
	if player.teleport:
		sprite.hide()
		teleport_sprite.show()
	else:
		teleport_sprite.hide()
		sprite.animation = "hit"
		sprite.show()
	show()

func _on_mouse_entered():
	moused = true

func _on_mouse_exited():
	moused = false
