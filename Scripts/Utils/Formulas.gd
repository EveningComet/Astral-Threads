## Stores various formulas.
class_name Formulas

# Scaling values
const VITALITY_HP_SCALER:              int = 3
const VITALITY_DEFENSE_SCALER:         int = 2
const TECHNIQUE_PHYSICAL_POWER_SCALER: int = 2
const WILL_SP_SCALER:                  int = 3
const WILL_SPECIAL_POWER_SCALER:       int = 2

## The base chance a character has of hitting something.
static var base_chance_to_hit: float = 90.0

## The base chance for landing a critical hit.
static var base_critical_hit_chance: float = 5.0

static var crit_chance_scaler: float = 8.0

## Wrapper/Helper for getting the calculated value for a cached stat.
static func get_calculated_value(stats: Stats, stat_type: StatHelper.StatTypes) -> float:
	match stat_type:
		StatHelper.StatTypes.MaxHP:
			return get_max_hp_value(stats)
		StatHelper.StatTypes.MaxSP:
			return get_max_sp_value(stats)
		StatHelper.StatTypes.PhysicalPower:
			return get_physical_power(stats)
		StatHelper.StatTypes.SpecialPower:
			return get_special_power(stats)
		StatHelper.StatTypes.Defense:
			return get_defense(stats)
		
		# Anything else can be calculated directly
		_:
			return stats.stats[stat_type].get_calculated_value()

static func get_max_hp_value(stats: Stats) -> int:
	var vitality_stat: Stat = stats.stats[StatHelper.StatTypes.Vitality]
	var vitality_value: int = floor(vitality_stat.get_calculated_value())
	var true_max_hp: Stat = Stat.new(vitality_value * VITALITY_HP_SCALER)
	var max_hp_stat: Stat = stats.stats[StatHelper.StatTypes.MaxHP]
	true_max_hp.raise_base_value_by(max_hp_stat.base_value)
	
	for mod: StatModifier in max_hp_stat.get_modifiers():
		true_max_hp.add_modifier(mod)
	return floor(true_max_hp.get_calculated_value())

static func get_max_sp_value(stats: Stats) -> int:
	var will_stat:   Stat = stats.stats[StatHelper.StatTypes.Will]
	var will_value:  int  = floor(will_stat.get_calculated_value())
	var true_max_sp: Stat = Stat.new(will_value * WILL_SP_SCALER)
	var max_sp_stat: Stat = stats.stats[StatHelper.StatTypes.MaxSP]
	true_max_sp.raise_base_value_by(max_sp_stat.get_base_value())
	
	for mod: StatModifier in max_sp_stat.get_modifiers():
		true_max_sp.add_modifier(mod)
	return floor(true_max_sp.get_calculated_value())

## Returns the passed character's physical power.
static func get_physical_power(stats: Stats) -> int:
	# 1st, get the needed attribute value
	var technique_stat: Stat = stats.stats[StatHelper.StatTypes.Technique]
	var technique_value: int = technique_stat.get_calculated_value()
	var true_physical_power: Stat = Stat.new(
		technique_value * TECHNIQUE_PHYSICAL_POWER_SCALER
	)
	
	# Then, combine it with whatever might be set in the physical power stats
	var physical_power: Stat = stats.stats[StatHelper.StatTypes.PhysicalPower]
	true_physical_power.raise_base_value_by( physical_power.get_base_value() )
	
	# Finally, calculate the final value by getting and using the modifiers
	# inside the relevant stat
	for mod: StatModifier in physical_power.get_modifiers():
		true_physical_power.add_modifier(mod)
	return floor( true_physical_power.get_calculated_value() )

## Returns the passed character's special power.
static func get_special_power(stats: Stats) -> int:
	# 1st, get the needed attribute value
	var will_stat:  Stat = stats.stats[StatHelper.StatTypes.Will]
	var will_value: int  = will_stat.get_calculated_value()
	var true_special_power: Stat = Stat.new(
		will_value * WILL_SPECIAL_POWER_SCALER
	)
	
	var special_power: Stat = stats.stats[StatHelper.StatTypes.SpecialPower]
	true_special_power.raise_base_value_by(special_power.get_base_value())
	
	for mod: StatModifier in stats.stats[StatHelper.StatTypes.SpecialPower].get_modifiers():
		true_special_power.add_modifier(mod)
	return floor( true_special_power.get_calculated_value() )

## Get the true defense.
static func get_defense(stats: Stats) -> int:
	var vitality_stat: Stat = stats.stats[StatHelper.StatTypes.Vitality]
	var vitality_value: int = vitality_stat.get_calculated_value()
	var true_defense:  Stat = Stat.new(vitality_value * VITALITY_DEFENSE_SCALER)
	
	var defense_stat:  Stat = stats.stats[StatHelper.StatTypes.Defense]
	true_defense.raise_base_value_by( defense_stat.get_base_value() )
	
	for mod: StatModifier in defense_stat.get_modifiers():
		true_defense.add_modifier(mod)
	return floor( true_defense.get_calculated_value() )

## Return a float percentage for damage resistance.
static func get_resistance(stats: Stats, damage_type: StatHelper.DamageTypes) -> float:
	if StatHelper.damage_to_res_map.has(damage_type) == true:
		return stats.stats[StatHelper.damage_to_res_map[damage_type]].get_calculated_value()
	return 0.0

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
