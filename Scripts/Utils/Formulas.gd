## Stores various formulas.
class_name Formulas

## The base chance a character has of hitting something.
static var base_chance_to_hit: float = 90.0

## The base chance for landing a critical hit.
static var base_critical_hit_chance: float = 5.0

static func get_chance_to_hit(
	activator: Combatant,
	receiver:  Combatant,
	success_chance: float
) -> int:
	return 0
