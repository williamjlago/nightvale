class_name WorldItem extends Sprite2D

var scene_path: String = "res://scenes/worlditem.tscn"
@export var data: ItemData

func _ready():
	texture = data.item_texture
	z_index = 0
	add_to_group("items")

func pickup():
	if InventoryManager.player:
		InventoryManager.add_item(data)
		queue_free()
