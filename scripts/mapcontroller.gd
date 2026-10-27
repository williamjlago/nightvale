extends Node

@export var map_name: String = ""
@onready var tilemap: TileMapLayer = get_node("WorldTileLayer")
@onready var tile_size: Vector2 = tilemap.tile_set.tile_size
@onready var player: Player = get_node("Player")
var enemy_scene: PackedScene = load("res://scenes/enemy.tscn")

func _ready():
	if Maps.is_initialized(map_name):
		_restore_enemies(Maps.get_enemy_records(map_name))
	else:
		tilemap.generate_enemies()
		Maps.mark_initialized(map_name)
		
	if Maps.has_pending_spawn:
		var spawn_tile = Maps.spawn_player()
		player.global_position = tilemap.to_global(tilemap.map_to_local(spawn_tile)) - (tile_size / 2)
		if player.fog:
			player.fog.update_fov()

func _exit_tree():
	var enemies: Array = []
	for child in get_children():
		if child.is_in_group("enemies"):
			enemies.append(child)
	Maps.save_enemies(map_name, enemies, tilemap)

func _restore_enemies(records: Array) -> void:
	for r in records:
		var enemy = enemy_scene.instantiate()
		enemy.enemy_id = r["id"]
		enemy.enemy_type = r["enemy_type"]
		enemy.health = r["health"]
		enemy.max_health = r["max_health"]
		enemy.level = r["level"]
		enemy.awake = r["awake"]
		add_child(enemy)
		enemy.global_position = tilemap.to_global(tilemap.map_to_local(r["tile_pos"])) - (tile_size / 2)
