## A class that stores variables related to different types of stats.
class_name StatHelper

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
	get: return [StatTypes.Vitality, StatTypes.Technique, StatTypes.Will]
