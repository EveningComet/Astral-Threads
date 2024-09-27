## A component that defines how a skill works.
class_name SkillEffect extends Resource

## Based on the stat being scaled, how much damage, healing, etc. to perform.
@export var power_scale: float = 1.0

## What stat does this use? Used as an enum to allow for 
@export var stat_used: StatHelper.StatTypes = StatHelper.StatTypes.PhysicalPower

## Get the power output using a character's stats.
func get_power(activator: Stats):
	match stat_used:
		# Edge case to prevent hp and sp from being used in calculations
		StatHelper.StatTypes.CurrentHP, StatHelper.StatTypes.CurrentSP:
			return 1
		
		StatHelper.StatTypes.PhysicalPower:
			return _get_physical_power(activator)
		
		StatHelper.StatTypes.SpecialPower:
			return _get_special_power(activator)
		
		# TODO: Return a calculated value depending on the stat.
		_:
			return 1

func _get_physical_power(activator: Stats) -> int:
	return floor( activator.get_physical_power() * power_scale )

func _get_special_power(activator: Stats) -> int:
	return floor( activator.get_special_power() * power_scale )
