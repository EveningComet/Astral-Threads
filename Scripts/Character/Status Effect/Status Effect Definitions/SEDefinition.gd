## Component used for telling a status effect what it should do.
class_name SEDefinition extends Resource

## For the definitions that deal damage, it needs to be a specific type.
@export var damage_type: StatHelper.DamageTypes = StatHelper.DamageTypes.Base

## For the definitions that change stats.
@export var stat_modifiers: Array[StatModifier] = []

func apply_modifiers(target: Combatant) -> void:
	for mod: StatModifier in stat_modifiers:
		target.stats.add_modifier(mod.stat_changing, mod)

func remove_modifiers(target: Combatant) -> void:
	for mod: StatModifier in stat_modifiers:
		target.stats.remove_modifier(mod.stat_changing, mod)
