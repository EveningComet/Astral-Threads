## Defines a skill that applies a status effect.
class_name ApplyStatusEffect extends SkillEffect

## The status effect that could be applied.
@export var status_effect: StatusEffect

## The chance of the status effect being applied.
@export_range(0.0, 1.0) var chance_to_apply: float = 0.5
