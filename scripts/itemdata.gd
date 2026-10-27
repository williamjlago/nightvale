class_name ItemData extends Resource

@export var item_texture: Texture2D # item texture to display
@export var item_name: String # name of item
@export var item_type: String # weapon, shield, chest, legs, flask, charm, etc.
@export var min_damage: float # only for weapons/shields
@export var max_damage: float # only for weapons/shields
@export var armor: float # armor bonus when equipped; only for equipment
@export var dodge: float # dodge bonus when equipped; only for equipment
@export var rarity: String # item's rarity: common, uncommon, rare, epic, unique, etc.
@export var usable: bool # does item have an on-use effect?
@export var cooldown: int # cooldown on one-use effect
var effect # define item on-use effect here; NYI
