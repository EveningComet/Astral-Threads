## Stores data for how a skill should be scaled at a particular upgrade level.
class_name SkillTier extends Resource

## The cost of the skill for this upgrade tier. Could be higher, could be lower.
@export var cost: int = 5

## The power scale for this tier.
@export var power_scale: float = 1.0

## Bonus damage for skills that deal extra damage when a debuff is present.
@export var bonus_damage_scale_on_debuffs_present: float = 0.0

## The amount of life steal for the skill at this tier.
@export var attacker_heal_percentage: float = 0.0

## The newer, more powerful versions of the permanent upgrade.
@export var stat_modifiers: Array[StatModifier] = []
