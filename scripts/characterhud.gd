extends Node2D

@onready var player = self.get_parent().get_parent()
@onready var hp_bar = get_node("hp_bar")

func _process(_delta):
	hp_bar.scale.x = (player.health / player.max_health)
