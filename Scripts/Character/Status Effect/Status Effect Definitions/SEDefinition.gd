## Component used for telling a status effect what it should do.
class_name SEDefinition extends Resource

@export_category("Modifiers")
## By using the stat modifier object, the amount of new code will be cut down.
@export var mod: StatModifier

@export_category("Damage Info")
## For the definitions that deal damage, it needs to be a specific type.
@export var damage_type: StatHelper.DamageTypes = StatHelper.DamageTypes.Base

@export var base_power_scale:     float = 1.0
@export var status_damage_scaler: float = 0.0

func trigger(target: Combatant, turns_elapsed: int = 0) -> void:
	pass

## Convert the effect to damage datas.
func to_damage_data(activator: Combatant = null) -> DamageData:
	var dd: DamageData      = DamageData.new()
	if activator != null:
		dd.activator = activator.stats
	dd.damage_amount        = mod.value
	dd.base_power_scale     = base_power_scale
	dd.status_damage_scaler = status_damage_scaler
	dd.damage_type          = damage_type
	return dd

func apply_modifier(target: Combatant) -> void:
	target.stats.add_modifier(mod.stat_changing, mod)

func remove_modifier(target: Combatant) -> void:
	target.stats.remove_modifier(mod.stat_changing, mod)
