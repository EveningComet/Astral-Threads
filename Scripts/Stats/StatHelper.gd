## A class that stores variables related to different types of stats.
class_name StatHelper

## Used to assist with accessing stats easily.
enum StatTypes {
	# Attributes
	Vitality,             ## For health, defense, etc.
	Technique,            ## For physical/regular damage, etc.
	Will,                 ## For mind, special points, etc.
	
	# Vitals
	MaxHP,                # Max hit points
	CurrentHP,            # Current hit points
	MaxSP,                # Our max mana/stamina/etc.
	CurrentSP,            # Our current mana/stamina/etc.
	
	# Other stats
	# These stats will store the "bonus" value
	CriticalHitChance,
	Speed,
	Evasion,
	Perception,
	
	# Modifiers for damage types
	PhysicalPower,
	SpecialPower,
	HeatMods,
	ColdMods,
	ElectricityMods,
	PsychicMods,
	
	# Resistances (Damage Type)
	# Except for regular damage, the rest are primarily percentage based (0.0-1.0)
	Defense,
	HeatRes,
	ColdRes,
	ElectricityRes,
	PsychicRes,
	
	# Resistances (Status Effects)
	# Percentage based (0.0-1.0)
	Plagued
}

## The different types of damage.
enum DamageTypes {
	Base,
	Heat,
	Cold,
	Electricity,
	Psychic,
	True ## Ignores resistance.
}

## Easy accessor for returning the resistance for damage types.
static var damage_to_res_map: Dictionary = {
	DamageTypes.Base: StatTypes.Defense,
	DamageTypes.Heat: StatTypes.HeatRes,
	DamageTypes.Cold: StatTypes.ColdRes,
	DamageTypes.Electricity: StatTypes.ElectricityRes,
	DamageTypes.Psychic: StatTypes.PsychicRes
}

## Wrapper for getting the attributes.
static var attributes: Array[StatTypes]:
	get:
		var to_return: Array[StatTypes]
		for i in range(StatTypes.Vitality, StatTypes.MaxHP):
			to_return.append(i)
		return to_return

## Return a list of the stat indexes without the attributes.
static func get_non_attributes_as_list() -> Array[int]:
	var to_return: Array[int] = []
	for i in range(StatTypes.size()):
		to_return.append(i)
	for i in range(StatTypes.MaxHP - 1, -1, -1):
		to_return.erase(i)
	return to_return

static func stat_types_to_string(stat_type: StatTypes) -> String:
	var lookup: Dictionary = {
		StatTypes.Vitality : "Vitality",
		StatTypes.Will : "Will",
		StatTypes.Perception : "Perception",
		StatTypes.Evasion : "Evasion",
		StatTypes.Speed : "Speed",
	}
	if stat_type in lookup.keys():
		return lookup[stat_type]
	return "Unknown stat type"
