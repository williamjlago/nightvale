extends Control

@onready var grid = $GridContainer
@onready var cursor_item: TextureRect = $cursor_item

func _ready():
	InventoryManager.inventory_updated.connect(_on_inventory_updated)
	InventoryManager.cursor_item_changed.connect(_on_cursor_item_changed)
	visibility_changed.connect(_on_visibility_changed)
	
	var i = 0
	for slot in grid.get_children():
		slot.slot_index = i
		i += 1
		
	cursor_item.mouse_filter = Control.MOUSE_FILTER_IGNORE
	cursor_item.visible = false
	InventoryManager.inventory_updated.emit()

func _process(_delta):
	if InventoryManager.cursor_item != null:
		cursor_item.global_position = get_global_mouse_position() - (cursor_item.size)

func _on_inventory_updated():
	var slot_num: int = 0
	for slot in grid.get_children():
		slot.set_item(InventoryManager.inventory[slot_num])
		slot_num += 1

func _on_cursor_item_changed():
	if InventoryManager.cursor_item:
		cursor_item.texture = InventoryManager.cursor_item.item_texture
		cursor_item.visible = true
	else:
		cursor_item.visible = false
	
func _on_visibility_changed():
	if not visible and InventoryManager.cursor_item != null:
		InventoryManager.cursor_item_return()

func _gui_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		if InventoryManager.cursor_item != null:
			InventoryManager.cursor_item_return()

func clear_grid():
	while grid.get_child_count() > 0:
		var child = grid.get_child(0)
		grid.remove_child(child)
		child.queue_free()
