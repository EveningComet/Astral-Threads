## For status effects that do something every turn.
class_name OnTickSED extends SEDefinition

## If this status changes a stat every turn, and we want that value to increase/decrease
## each turn, this will help control that.
@export_range(0.0, 1.0, 0.05) var increase_ratio_per_turn: float = 0.0

func trigger(target: Combatant, elapsed_turns: int = 0) -> void:
	# Depending on the stat being changed, different things will need to be done
	match mod.stat_changing:
		
		StatHelper.StatTypes.CurrentHP:
			
			# For convenience, negative values will be considered healing
			if mod.get_value() < 0.0:
				var amount: int = abs(mod.get_value())
				target.stats.heal(amount)
			
			else:
				target.stats.take_damage([to_damage_data()])
		
		StatHelper.StatTypes.CurrentSP:
			# For convenience, negative values will be considered healing
			if mod.get_value() < 0.0:
				var amount = abs(mod.get_value())
				target.stats.regain_sp(amount)
			
			else:
				var amount = abs(mod.get_value())
				target.stats.remove_sp(amount)
		
		# Everything else can be done normally
		_:
			pass
