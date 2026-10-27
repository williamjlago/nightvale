extends Node

@export var dest_map: String
@export var dest_pos: Vector2i

func _ready():
	add_to_group("warps")
