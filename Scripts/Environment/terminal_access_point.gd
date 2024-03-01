extends Area2D

@export var targets : Vector3i

var progress = [[0, 0], [0, 0], [0, 0]]
var level_manager

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
		if progress[i][0] == progress[i][1]:
			get_node("Byte"+str(i+1)+"Sprite").show()
		else:
			get_node("Byte"+str(i+1)+"Sprite").hide()
			all_good = false
	if all_good:
		$BaseSprite.texture.region.position.x = 0
		$AnimatedSprite2D.animation = "green"
	else:
		$BaseSprite.texture.region.position.x = 80
		$AnimatedSprite2D.animation = "red"
