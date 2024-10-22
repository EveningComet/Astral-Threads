## Container for a character's status effects.
class_name StatusEffectHolder extends Resource

## Stores a status effect.
## {status effect name : status effect object}
var statuses: Dictionary = {}

## The character being kept track of.
var combatant: Combatant

func _init(_com: Combatant = null) -> void:
	combatant = _com

## Add a copy of a status effect, and trigger any on apply effects if they exist.
func add_status_effect(new_status: StatusEffect) -> void:
	if statuses.has(new_status.localization_name) == false:
		statuses[new_status.localization_name] = new_status.duplicate()
		new_status.trigger_on_apply(combatant)
	
	# Simply increase how many turns are left
	else:
		statuses[new_status.localization_name].duration_in_turns += new_status.duration_in_turns

func tick_statuses() -> void:
	for status: StatusEffect in statuses.values():
		if status.lifetime_in_turns >= status.duration_in_turns:
			remove_status_effect(status)
		else:
			status.lifetime_in_turns += 1
			status.trigger_on_tick(combatant)

func remove_status_effect(status_to_remove: StatusEffect) -> void:
	statuses[status_to_remove.localization_name].trigger_on_expire(combatant)
	statuses.erase(status_to_remove.localization_name)
	
## Are there status effects considered negative?
func has_negative_statuses_present() -> bool:
	for status: StatusEffect in statuses.values():
		if status.is_negative == true:
			return true
	return false
