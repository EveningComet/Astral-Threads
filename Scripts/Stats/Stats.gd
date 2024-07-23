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
	stats[StatHelper.StatTypes.MaxHP]     = Stat.new(50)
	stats[StatHelper.StatTypes.CurrentHP] = get_max_hp()
	stats[StatHelper.StatTypes.MaxSP]     = Stat.new(50)
	stats[StatHelper.StatTypes.CurrentSP] = get_max_sp()
	
	# Other stats
	stats[StatHelper.StatTypes.Defense] = Stat.new(5)

func get_max_hp() -> int:
	return round(stats[StatHelper.StatTypes.MaxHP].get_calculated_value())

func get_curr_hp() -> int:
	return stats[StatHelper.StatTypes.CurrentHP]

func get_max_sp() -> int:
	return round(stats[StatHelper.StatTypes.MaxSP].get_calculated_value())
	
func get_curr_sp() -> int:
	return stats[StatHelper.StatTypes.CurrentSP]

func get_defense() -> int:
	return floor(stats[StatHelper.StatTypes.Defense].get_calculated_value())

func add_modifier(stat_type, mod: StatModifier) -> void:
	pass

func remove_modifier(stat_type, mod: StatModifier) -> void:
	pass
	
func take_damage(damage_data) -> void:
	damage_data -= get_defense()
	stats[StatHelper.StatTypes.CurrentHP] -= damage_data
	combatant.stat_changed.emit(combatant)
	# Notify anything about dying
	if get_curr_hp() <= 0:
		Eventbus.hp_depleted.emit(combatant)
		stats[StatHelper.StatTypes.CurrentHP] = 0
		combatant.stat_changed.emit(combatant)
		combatant.get_parent().queue_free()

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
