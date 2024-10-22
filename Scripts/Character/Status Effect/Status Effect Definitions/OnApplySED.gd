## Defines what a status effect does on apply.
class_name OnApplySED extends SEDefinition

func trigger(combatant: Combatant, turns_elapsed: int = 0) -> void:
	apply_modifier(combatant)
