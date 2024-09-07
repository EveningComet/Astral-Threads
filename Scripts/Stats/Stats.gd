## Stores a collection of different stats.
class_name Stats extends Resource

## A key value pair of the stats. {StatType = Stat Object}
var stats: Dictionary = {}

## The attached character.
var combatant: Combatant

func _init(_com: Combatant) -> void:
	combatant = _com
	initialize()

## Initialize with filler stats.
func initialize() -> void:
	# Attributes
	stats[StatHelper.StatTypes.Vitality]     = Stat.new(5)
	stats[StatHelper.StatTypes.Technique]    = Stat.new(5)
	stats[StatHelper.StatTypes.Will]         = Stat.new(5)
	
	# Vitals
	stats[StatHelper.StatTypes.MaxHP]     = Stat.new(15)
	stats[StatHelper.StatTypes.CurrentHP] = get_max_hp()
	stats[StatHelper.StatTypes.MaxSP]     = Stat.new(15)
	stats[StatHelper.StatTypes.CurrentSP] = get_max_sp()
	
	initialize_derived_stats()

func initialize_derived_stats() -> void:
	# Other stats
	stats[StatHelper.StatTypes.Defense] = Stat.new(5)
	stats[StatHelper.StatTypes.Speed] = Stat.new(
		0
	)
	stats[StatHelper.StatTypes.Perception] = Stat.new(
		0
	)
	
	# This is the "bonus" evasion
	stats[StatHelper.StatTypes.Evasion] = Stat.new(
		0
	)
	
	# This is the "bonus" critical hit chance
	stats[StatHelper.StatTypes.CriticalHitChance] = Stat.new(
		0
	)
	
	# Initialize the "bonus" powers
	stats[StatHelper.StatTypes.PhysicalPower] = Stat.new(0)
	stats[StatHelper.StatTypes.SpecialPower]  = Stat.new(0)
	stats[StatHelper.StatTypes.HeatMods]      = Stat.new(0)
	stats[StatHelper.StatTypes.ColdMods]      = Stat.new(0)
	stats[StatHelper.StatTypes.ElectricityMods] = Stat.new(0)
	stats[StatHelper.StatTypes.PsychicMods]     = Stat.new(0)
	
	# Initialize the resistances
	for t in StatHelper.damage_to_res_map:
		var stat_type = StatHelper.damage_to_res_map[t]
		stats[stat_type] = Stat.new(0)

func get_max_hp() -> int:
	return round(stats[StatHelper.StatTypes.MaxHP].get_calculated_value())

func get_curr_hp() -> int:
	return stats[StatHelper.StatTypes.CurrentHP]

func get_max_sp() -> int:
	return round(stats[StatHelper.StatTypes.MaxSP].get_calculated_value())
	
func get_curr_sp() -> int:
	return stats[StatHelper.StatTypes.CurrentSP]

## Return a float percentage for damage resistance.
func get_resistance(damage_type: StatHelper.DamageTypes) -> float:
	if StatHelper.damage_to_res_map.has(damage_type) == true:
		return stats[StatHelper.damage_to_res_map[damage_type]].get_calculated_value()
	return 0.0

# TODO: Method for resistances.
func get_defense() -> int:
	return floor(stats[StatHelper.StatTypes.Defense].get_calculated_value())

# TODO: Account for raising the max values of certain stats.
## Wrapper for permanently increasing the base value of a particular stat.
## Mainly used to raise a character's attributes.
func raise_base_value_by(stat_raising: StatHelper.StatTypes, amt: int) -> void:
	stats[stat_raising].raise_base_value_by(amt)
	combatant.stat_changed.emit( combatant )

func add_modifier(stat_type: StatHelper.StatTypes, mod_to_add: StatModifier) -> void:
	stats[stat_type].add_modifier( mod_to_add )
	combatant.stat_changed.emit( combatant )

func remove_modifier(stat_type: StatHelper.StatTypes, mod_to_remove: StatModifier) -> void:
	stats[stat_type].remove_modifier( mod_to_remove )
	combatant.stat_changed.emit( combatant )
	
func take_damage(damage_datas: Array[DamageData]) -> void:
	for dd: DamageData in damage_datas:
		var amount: int = dd.damage_amount
		var damage_type = dd.damage_type
		
		# Checking if damage needs to be increased based on negative status effects
		if combatant.status_effect_holder.has_negative_statuses_present() == true:
			pass
		
		# Account for damage types and resistances.
		match damage_type:
			StatHelper.DamageTypes.Base:
				amount -= get_defense()
			
			# All other damage types get scaled
			_:
				var a = 1.0 - get_resistance(damage_type)
				amount = floor(amount * a)
		
		# Finally apply the damage
		amount = clamp(amount, 1, dd.damage_amount)
		stats[StatHelper.StatTypes.CurrentHP] -= amount
		combatant.stat_changed.emit(combatant)
		
		# TODO: Lifesteal check
		if dd.damage_heal_percentage > 0.0:
			pass
		
		# Notify anything about dying
		if get_curr_hp() <= 0:
			die()

func die() -> void:
	stats[StatHelper.StatTypes.CurrentHP] = 0
	combatant.stat_changed.emit(combatant)
	Eventbus.hp_depleted.emit(combatant)

func heal(amount: int) -> void:
	stats[StatHelper.StatTypes.CurrentHP] += amount
	if get_curr_hp() > get_max_hp():
		stats[StatHelper.StatTypes.CurrentHP] = get_max_hp()

func remove_sp(amount: int) -> void:
	stats[StatHelper.StatTypes.CurrentSP] -= amount
	combatant.stat_changed.emit( combatant )
	stats[StatHelper.StatTypes.CurrentSP] = max(
		get_curr_sp(),
		0
	)

func regain_sp(amount: int) -> void:
	stats[StatHelper.StatTypes.CurrentSP] += amount
	if get_curr_sp() > get_max_sp():
		stats[StatHelper.StatTypes.CurrentSP] = get_max_sp()
