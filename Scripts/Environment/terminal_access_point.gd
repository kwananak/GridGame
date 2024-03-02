extends Area2D

var tile_type = "access_point"
var level_manager
var progress = [[0, 0], [0, 0], [0, 0]]
var vulnerable

@export var strength = 3
@export var targets : Vector3i

@onready var anim = $AnimatedSprite2D

func _ready():
	level_manager = get_tree().get_first_node_in_group("VirtualLevelManager")
	level_manager.barrier_down.connect(update_progress)
	progress[0][1] = targets.x
	progress[1][1] = targets.y
	progress[2][1] = targets.z
	set_sprites()

func update_progress():
	for i in level_manager.barriers_down.size():
		progress[i][0] = level_manager.barriers_down[i]
	set_sprites()

func set_sprites():
	var all_good = true
	for i in progress.size():
		get_node("BaseSprite/Label"+str(i+1)).text = str(progress[i][0]) + "/" + str(progress[i][1])
		if progress[i][0] == progress[i][1]:
			get_node("BaseSprite/Byte"+str(i+1)+"Sprite").show()
		else:
			get_node("BaseSprite/Byte"+str(i+1)+"Sprite").hide()
			all_good = false
	if all_good:
		$BaseSprite.texture.region.position.x = 0
		anim.animation = "green"
		vulnerable = true
	else:
		$BaseSprite.texture.region.position.x = 80
		anim.animation = "red"
		vulnerable = false

func hit_by_player(hit):
	if vulnerable:
		$hit.play()
		var frame = anim.frame
		$BaseSprite.texture.region.position.x = 208
		anim.animation = "hit"
		anim.frame = frame
		for i in randi_range(4, 6):
			var pos = Vector2(randi_range(-3, 3), randi_range(-3, 3))
			anim.position = pos
			$BaseSprite.position = pos + Vector2(-16, 0)
			await get_tree().create_timer(0.05).timeout
		frame = anim.frame
		$BaseSprite.texture.region.position.x = 0
		anim.animation = "green"
		anim.frame = frame
		if hit is int:
			strength -= hit
		else:
			strength -= 1
		if strength <= 0:
			for n in get_tree().get_nodes_in_group("VirtualEndTile"):
				if n.global_position == global_position:
					n.on = true
					n.get_node("AnimatedSprite2D").show()
			$BaseSprite.hide()
			$destroy.play()
			anim.animation = "destruction"
			await $destroy.finished
			queue_free()
