extends Node

# map_id -> { "initialized": bool, "enemies": Array, "items": Array }
var maps: Dictionary = {}
var spawn_tile: Vector2i = Vector2i.ZERO
var has_pending_spawn: bool = false

const MAP_SCENES := {
	"overworld": "res://scenes/overworld.tscn",
	"dungeon01": "res://scenes/dungeon01.tscn",
}

func is_initialized(map_id: String) -> bool:
	return maps.has(map_id) and maps[map_id]["initialized"]

func mark_initialized(map_id: String) -> void:
	if not maps.has(map_id):
		maps[map_id] = {"initialized": true, "enemies": [], "items": []}
	else:
		maps[map_id]["initialized"] = true

func save_enemies(map_id: String, enemies: Array, tilemap: TileMapLayer) -> void:
	var records := []
	for e in enemies:
		if e.dead:
			continue  # dead enemies just don't get re-added
		records.append({
			"id": e.enemy_id,
			"enemy_type": e.enemy_type,
			"tile_pos": tilemap.local_to_map(tilemap.to_local(e.global_position)),
			"health": e.health,
			"max_health": e.max_health,
			"level": e.level,
			"awake": e.awake,
		})
	maps[map_id]["enemies"] = records

func get_enemy_records(map_id: String) -> Array:
	return maps[map_id]["enemies"] if maps.has(map_id) else []

func get_scene_path(map_name: String) -> String:
	return MAP_SCENES.get(map_name, "")
	
func request_warp(dest_map: String, dest_pos: Vector2i) -> void:
	var scene_path = get_scene_path(dest_map)
	if scene_path == "":
		push_error("SceneTransition: unknown map '%s'" % dest_map)
		return
	spawn_tile = dest_pos
	has_pending_spawn = true
	get_tree().change_scene_to_file(scene_path)

func spawn_player() -> Vector2i:
	has_pending_spawn = false
	return spawn_tile
