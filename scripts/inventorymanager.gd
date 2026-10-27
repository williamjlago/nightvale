extends Node

var inventory: Array = []
var equipment: Dictionary = {}
var gold: int = 0
var player: Player

var cursor_item: ItemData = null
var cursor_item_origin: Dictionary = {} # {"type": "inventory", "key": int} or {"type": "equipment", "key": "String"}

signal inventory_updated
signal equipment_updated
signal cursor_item_changed

const EQUIPMENT_SLOTS := [
	"main_hand", "off_hand", "head", "neck", "chest", "legs",
	"hands", "feet", "light", "belt", "ring1", "ring2"
]

func _ready():
	inventory.resize(32)
	for slot_type in EQUIPMENT_SLOTS:
		equipment[slot_type] = null

func set_player(p: Player):
	player = p

func add_item(item: ItemData) -> bool:
	for i in range(inventory.size()):
		if inventory[i] == null:
			inventory[i] = item
			inventory_updated.emit()
			return true
	return false

func cursor_item_pickup(index: int) -> void:
	if cursor_item != null or inventory[index] == null:
		return
	cursor_item = inventory[index]
	cursor_item_origin = {"type": "inventory", "key": index}
	inventory[index] = null
	inventory_updated.emit()
	cursor_item_changed.emit()

func cursor_item_place(index: int) -> void:
	if cursor_item == null:
		return
	var displaced_item = inventory[index]
	inventory[index] = cursor_item
	cursor_item = displaced_item # swap items on cursor if slot has one already
	cursor_item_origin = {"type": "inventory", "key": index} if displaced_item != null else {}
	inventory_updated.emit()
	cursor_item_changed.emit()

func equipment_item_pickup(slot_type: String) -> void:
	if cursor_item != null or equipment.get(slot_type) == null:
		return
	cursor_item = equipment[slot_type]
	cursor_item_origin = {"type": "equipment", "key": slot_type}
	equipment[slot_type] = null
	#_recalculate_player_stats()
	equipment_updated.emit()
	cursor_item_changed.emit()

func equipment_item_place(slot_type: String) -> void:
	if cursor_item == null or cursor_item.item_type != slot_type:
		return # wrong equipment type, can't place it here
	var displaced_item = equipment[slot_type]
	equipment[slot_type] = cursor_item
	cursor_item = displaced_item
	cursor_item_origin = {"type": "equipment", "key": slot_type} if displaced_item != null else {}
	_recalculate_player_stats()
	equipment_updated.emit()
	cursor_item_changed.emit()

func cursor_item_return() -> void:
	if cursor_item == null:
		return
	var origin_type = cursor_item_origin.get("type", "")
	var key = cursor_item_origin.get("key")
	var placed := false
	if origin_type == "inventory" and inventory[key] == null:
		inventory[key] = cursor_item
		placed = true
	elif origin_type == "equipment" and equipment[key] == null:
		equipment[key] = cursor_item
		placed = true
		_recalculate_player_stats()
	if not placed:
		add_item(cursor_item)
	cursor_item = null
	cursor_item_origin = {}
	inventory_updated.emit()
	equipment_updated.emit()
	cursor_item_changed.emit()

func cursor_item_drop() -> void:
	if cursor_item == null:
		return
	if player:
		var world_item = load("res://scenes/worlditem.tscn").instantiate()
		world_item.data = cursor_item
		get_tree().current_scene.add_child(world_item)
		world_item.global_position = player.global_position
	cursor_item = null
	cursor_item_origin = {}
	cursor_item_changed.emit()

func _recalculate_player_stats() -> void:
	if player:
		#player.recalculate_equipment_stats(equipment)
		pass

func _unhandled_input(event: InputEvent) -> void:
	if cursor_item != null and event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		cursor_item_drop()
		get_viewport().set_input_as_handled()
