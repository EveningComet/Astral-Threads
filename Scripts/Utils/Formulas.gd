## Stores various formulas.
class_name Formulas

## The base chance a character has of hitting something.
static var base_chance_to_hit: float = 90.0

## The base chance for landing a critical hit.
static var base_critical_hit_chance: float = 5.0

static var crit_chance_scaler: float = 8.0

## The chance a character has to hit a target.
## % chance = base_chance or skill_chance + ( attacker perception - defender evasion )
static func get_chance_to_hit(
	activator: Combatant,
	receiver:  Combatant,
	success_chance: float = base_chance_to_hit
) -> int:
	var perception:     int = activator.stats.get_perception()
	var target_evasion: int = receiver.stats.get_evasion()
	var result:         int = floor( success_chance + (perception - target_evasion) )
	return result

## Get the chance this character has to perform critical hits.
static func get_crit_chance(activator: Combatant):
	var stats: Dictionary = activator.stats.stats
	var a: float = activator.stats.stats[StatHelper.StatTypes.Technique].get_calculated_value()
	var b: float = stats[StatHelper.StatTypes.CriticalHitChance].get_calculated_value()
	var chance: float = (a + b) / crit_chance_scaler
	return floor( max(base_critical_hit_chance, chance) )
