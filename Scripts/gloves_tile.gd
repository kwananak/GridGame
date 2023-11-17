extends Area2D

var tile_type = "artefact"
enum Artefact {GLOVES, ARMOR, GOGGLES, ROD, BOOTS}
@export var artefact_type : Artefact

func pick_up():
	get_node("/root/Main/ArtefactHolder").add_artefact(artefact_type)
	queue_free()
