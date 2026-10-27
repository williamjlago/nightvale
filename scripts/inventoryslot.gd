class_name InventorySlot extends Control

var slot_index: int = -1
@onready var item_texture: TextureRect = $item_texture
@onready var item_button: Button = $item_button
var item_data: ItemData = null

func _ready():
	item_button.pressed.connect(_on_item_button_pressed)

func _on_item_button_pressed() -> void:
	if InventoryManager.cursor_item != null:
		InventoryManager.cursor_item_place(slot_index)
	elif item_data != null:
		InventoryManager.cursor_item_pickup(slot_index)

func set_item(new_item_data: ItemData) -> void:
	item_data = new_item_data
	if item_data:
		item_texture.texture = item_data.item_texture
		item_texture.visible = true
	else:
		item_texture.texture = null
		item_texture.visible = false
