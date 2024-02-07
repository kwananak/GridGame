extends Control

@onready var active_node = $Careful
@onready var basic_diamond_prefab = preload("res://Scenes/Tiles/basic_diamond.tscn")

func _ready():
	spawn_diamonds()

func spawn_diamonds():
	while true:
		await get_tree().create_timer(randf_range(0.1, 1.0)).timeout
		add_child(basic_diamond_prefab.instantiate())
