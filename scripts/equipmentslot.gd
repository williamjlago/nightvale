class_name EquipmentSlot extends InventorySlot

@export var slot_type: String = ""
@export var slot_texture: Texture2D
@onready var icon = $slot_icon

func _ready():
	icon.texture = slot_texture
	item_button.pressed.connect(_on_item_button_pressed)

func _on_item_button_pressed() -> void:
	if InventoryManager.cursor_item != null:
		InventoryManager.equipment_item_place(slot_type)
	elif item_data != null:
		InventoryManager.equipment_item_pickup(slot_type)
