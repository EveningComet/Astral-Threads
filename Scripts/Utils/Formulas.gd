## Stores various formulas.
class_name Formulas

## The base chance a character has of hitting something.
static var base_chance_to_hit: float = 90.0

## The base chance for landing a critical hit.
static var base_critical_hit_chance: float = 5.0

## The chance a character has to hit a target.
static func get_chance_to_hit(
	activator: Combatant,
	receiver:  Combatant,
	success_chance: float = base_chance_to_hit
) -> int:
	# TODO: Proper chance to hit.
	var perception: int = 0
	var target_evasion: int = 0
	var result: int = base_chance_to_hit
	return result
