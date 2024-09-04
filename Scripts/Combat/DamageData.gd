## Wrapper for damage information.
class_name DamageData extends Resource

var damage_type: StatHelper.DamageTypes = StatHelper.DamageTypes.Base

var damage_amount: int = 0

## Scales the damage based on the target having a negative status effect.
var status_damage_scaler: float = 1.0

## Heals the attacker based on a percentage of the damage dealt.
var damage_heal_percentage: float = 0.0
