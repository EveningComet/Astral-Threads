## Stores a collection of different stats.
class_name Stats extends Resource

## Fired when a character should be considered KO'd/dead/etc.
signal hp_depleted

## Fired whenever a stat's value changes.
signal stat_changed(stats: Stats)

## A key, value pair storing the stats for easy access and cleanliness.
@export var stats: Dictionary[StatHelper.StatTypes, Stat] = {}

## The attached character.
var combatant: Combatant

var curr_hp: int:
	get: return stats[StatHelper.StatTypes.CurrentHP].get_base_value()
	set(new_value):
		var temp = new_value
		if temp > max_hp:
			temp = max_hp
		stats[StatHelper.StatTypes.CurrentHP].set_base_value(temp)
		stat_changed.emit( self )

var max_hp: int:
	get: return Formulas.get_max_hp_value(self)

var curr_sp: int:
	get: return stats[StatHelper.StatTypes.CurrentSP].get_base_value()
	set(new_value):
		var temp = new_value 
		temp = clamp(temp, 0, max_sp)
		stats[StatHelper.StatTypes.CurrentSP].set_base_value(temp)
		stat_changed.emit( self )

var max_sp: int:
	get: return Formulas.get_max_sp_value(self)

func add_modifier(stat_type: StatHelper.StatTypes, mod_to_add: StatModifier) -> void:
	stats[stat_type].add_modifier( mod_to_add )
	stat_changed.emit( self )

func remove_modifier(stat_type: StatHelper.StatTypes, mod_to_remove: StatModifier) -> void:
	stats[stat_type].remove_modifier( mod_to_remove )
	stat_changed.emit( self )

func take_damage(damage_datas: Array[DamageData]) -> void:
	for dd: DamageData in damage_datas:
		var damage_amount: int = dd.damage_amount
		var damage_type := dd.damage_type
		
		# Subtract the damage based on the damage type
		match damage_type:
			StatHelper.DamageTypes.Base:
				damage_amount -= Formulas.get_defense(self)
			
			# All other damage types get scaled
			_:
				var a: float = 1.0 - Formulas.get_resistance(self, damage_type)
				damage_amount = floor(float(damage_amount) * a)
		
		# Finally, apply the damage
		curr_hp -= max(1, damage_amount)
		
		# Lifesteal check
		if dd.damage_heal_percentage > 0.0:
			var lifesteal_v: int = dd.get_lifesteal_amount(damage_amount, self)
			dd.activator.heal(lifesteal_v)
	
	if curr_hp <= 0:
		die()

func heal(amount: int) -> void:
	curr_hp += amount

func full_restore() -> void:
	curr_hp = max_hp
	curr_sp = max_sp

func remove_sp(amount_to_remove: int) -> void:
	curr_sp -= amount_to_remove

func die() -> void:
	hp_depleted.emit()
