## Defines a skill that should do some amount of damage.
class_name DamageEffect extends SkillEffect

## Dictates what type of damage this skill does.
@export var damage_type: StatHelper.DamageTypes = StatHelper.DamageTypes.Base

## If the target has at least one debuff applied to them, how much extra damage
## should be applied?
@export var bonus_damage_scale_on_debuffs_present: float = 0.0

## Scales the percentage of damage that should be healed for the attacker.
@export_range(0.0, 1.0) var attacker_heal_percentage: float = 0.0
