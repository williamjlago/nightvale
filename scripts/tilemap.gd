extends TileMapLayer

@export var num_enemies: int = 0
@onready var enemy_gen: EnemyGenerator = EnemyGenerator.new()

func get_actor_at(tile: Vector2i) -> Actor:
	for actor in TurnManager.actors:
		if local_to_map(to_local(actor.global_position)) == tile:
			return actor
	return null

func actor_at(tile: Vector2i) -> bool:
	for actor in TurnManager.actors:
		if local_to_map(to_local(actor.global_position)) == tile:
			return true
	return false
	
func item_at(tile: Vector2i) -> bool:
	for item in get_tree().get_nodes_in_group("items"):
		if local_to_map(to_local(item.global_position)) == tile:
			return true
	return false

func generate_enemies():
	add_child(enemy_gen)
	enemy_gen.place_enemies(num_enemies)
