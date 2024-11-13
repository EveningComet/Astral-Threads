## Component that represents a character that can take damage and die in the
## game world.
class_name Combatant extends Resource

## Event that gets fired whenever a stat changed.
signal stat_changed(com: Combatant)

## The component that stores all of a characters stats for tidyness.
@export var stats: Stats = Stats.new(self)

## The holder for a character's status effects.
var status_effect_holder: StatusEffectHolder = StatusEffectHolder.new(self)

## Container for the character's skills.
var skill_holder: SkillHolder = SkillHolder.new()

## Stores this participant's visual appearance.
var portrait_data: PortraitData
