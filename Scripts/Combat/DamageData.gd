## Wrapper for damage information.
class_name DamageData extends Resource

var damage_type: StatHelper.DamageTypes = StatHelper.DamageTypes.Base

var damage_amount: int = 0

## The base power scale.
var base_power_scale: float = 0.0

## Scales the damage based on the target having a negative status effect.
var status_damage_scaler: float = 0.0

## Heals the attacker based on a percentage of the damage dealt.
var damage_heal_percentage: float = 0.0

func get_debuff_scaled_damage(base_amount: int) -> int:
	var new_amount: int = base_amount
	return new_amount

## Get the lifesteal which is based on the stored percentage, the damage type,
## and the target's health.
func get_lifesteal_amount(final_damage_amount: int, target: Combatant) -> int:
	var lifesteal_amount: int = 0
	var damage: int = final_damage_amount
	lifesteal_amount = floor( damage * damage_heal_percentage )
	
	# Make sure the lifesteal is not outside of the range of the target's health
	# and return it
	lifesteal_amount = clamp(lifesteal_amount, 1, target.stats.get_curr_hp())
	return lifesteal_amount
