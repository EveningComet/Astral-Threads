## Wrapper for damage information.
class_name DamageData extends Resource

## The stats component of the character performing the damage.
var activator: Stats

var damage_type: StatHelper.DamageTypes = StatHelper.DamageTypes.Base

var damage_amount: int = 0

## The base power scale.
var base_power_scale: float = 0.0

## Scales the damage based on the target having a negative status effect.
var status_damage_scaler: float = 0.0

## Heals the attacker based on a percentage of the damage dealt.
var damage_heal_percentage: float = 0.0

func get_debuff_scaled_damage() -> int:
	var new_amount: int = floor(
		float(damage_amount) * (base_power_scale + status_damage_scaler)
	)
	return new_amount

## Get the lifesteal which is based on the stored percentage, the damage type,
## and the target's health.
func get_lifesteal_amount(final_damage_amount: int, target: Stats) -> int:
	var damage: float = float(final_damage_amount)
	var lifesteal_amount: int = floor( damage * damage_heal_percentage )
	
	# Make sure the lifesteal is not outside of the range of the target's health
	# and return it
	lifesteal_amount = clamp(lifesteal_amount, 1, max(1, target.get_curr_hp()))
	return lifesteal_amount
