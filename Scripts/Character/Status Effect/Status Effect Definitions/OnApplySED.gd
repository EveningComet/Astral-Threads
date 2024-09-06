## Defines what a status effect does on apply.
class_name OnApplySED extends SEDefinition

func trigger(combatant: Combatant) -> void:
	var m
	apply_modifiers(combatant)
