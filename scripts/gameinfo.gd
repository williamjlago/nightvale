extends Node

var max_health: float = 100
var health: float = 100
var level: int = 1
var experience: int = 0
var exp_to_next_level: int = 50
var attack_power: float = 0
var strength: int = 10
var dexterity: int = 10
var vitality: int = 10
var intellect: int = 10
var wisdom: int = 10
var luck: int = 10
var accuracy: float = 0
var spell_accuracy: float = 0
var dodge: float = 0
var armor: float = 0

var all_skills: Array[Skill] = []
var player_skills: Array[Skill] = []

func _init():
	populate_skills()

func save_from_player(player: Player) -> void:
	max_health = player.max_health
	health = player.health
	level = player.level
	attack_power = player.attack_power
	strength = player.strength
	dexterity = player.dexterity
	vitality = player.vitality
	intellect = player.intellect
	wisdom = player.wisdom
	luck = player.luck
	experience = player.experience
	exp_to_next_level = player.exp_to_next_level
	accuracy = player.accuracy
	spell_accuracy = player.spell_accuracy
	dodge = player.dodge
	armor = player.armor

func load_into_player(player: Player) -> void:
	player.max_health = max_health
	player.health = health
	player.level = level
	player.attack_power = attack_power
	player.strength = strength
	player.dexterity = dexterity
	player.vitality = vitality
	player.intellect = intellect
	player.wisdom = wisdom
	player.luck = luck
	player.experience = experience
	player.exp_to_next_level = exp_to_next_level
	player.accuracy = accuracy
	player.spell_accuracy = spell_accuracy
	player.dodge = dodge
	player.armor = armor

func populate_skills():
	
	var skill_desc = "Attack an enemy while moving up to one space forward, or up to two spaces starting at skill level 6."
	var skill = Skill.new("Advance", skill_desc, 15, 0, 0, "attack", 1)
	all_skills.append(skill)
	
	skill_desc = "Strike an enemy with a powerful blow that may stun. Higher levels have higher stun chance."
	skill = Skill.new("Power Strike", skill_desc, 15, 0, 6, "attack", 1)
	all_skills.append(skill)
