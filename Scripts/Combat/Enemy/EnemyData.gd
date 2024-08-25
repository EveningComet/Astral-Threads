## Stores data related to an enemy.
class_name EnemyData extends Resource

@export var localization_name: String = "New Enemy"
@export_multiline var localization_description: String = "A monstar."

## The 2D representation of this enemy.
@export var portrait: Texture2D

## Prefab of how this enemy should be displayed.
@export var world_model: PackedScene

@export_category("Stats")
@export var vitality:  int = 5
@export var technique: int = 5
@export var will:      int = 5

## Used to further tweak stats for enemies.
@export var stat_modifiers: Array[StatModifier] = []

@export_category("Rewards")
@export var xp_on_death:    int = 25
@export var money_on_death: int = 30
