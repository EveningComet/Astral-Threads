## Stores data related to an enemy.
class_name EnemyData extends Resource

@export var localization_name: String = "New Enemy"
@export_multiline var localization_description: String = "A monstar."

## The 2D representation of this enemy.
# TODO: Portrait data.
@export var portrait: Texture2D

## Used to make certain enemies "appear" larger in the battle menu.
@export var dimensions: Vector2 = Vector2(64, 64)

## Prefab of how this enemy should be displayed.
@export var world_model: PackedScene

@export_category("Stats")
@export var vitality:  int = 5
@export var technique: int = 5
@export var will:      int = 5

## Used to further tweak stats for enemies.
@export var stat_modifiers: Array[StatModifier] = []

## The skills available to this enemy.
@export var skills: Array[SkillData] = []

@export_category("Rewards")
@export var xp_on_death:    int = 25
@export var money_on_death: int = 30

@export_category("AI")
## How "brutal" an enemy is between 0 and 1. Higher values mean the enemy
## will perform the better action more often.
@export_range(0.0, 1.0) var efficiency: float = 0.25

## The possible stuff an AI can do. Attack someone, heal ally, etc.
@export var behaviors: Array[UtilityAIBehavior] = []
