## Container for a character's status effects.
class_name StatusEffectHolder extends Resource

## {status effect : turns left}
var statuses: Dictionary = {}

## The character being kept track of.
var combatant: Combatant

func _init(_com: Combatant) -> void:
	combatant = _com

## Add a status effect, and trigger any on apply effects if they exist.
func add_status_effect(new_status: StatusEffect) -> void:
	if statuses.has(new_status) == false:
		statuses[new_status] = new_status.base_duration_in_turns
		new_status.trigger_on_apply(combatant)
	else:
		statuses[new_status] += new_status.base_duration_in_turns

func tick_statuses() -> void:
	for status: StatusEffect in statuses:
		if statuses[status] <= 0:
			remove_status_effect(status)
		else:
			var turns_elapsed: int = status.base_duration_in_turns - statuses[status] + 1

func remove_status_effect(status_to_remove: StatusEffect) -> void:
	statuses[status_to_remove].trigger_on_expire(combatant)
	statuses.erase(status_to_remove)
	

## Are there status effects considered negative?
func has_negative_statuses_present() -> bool:
	for status: StatusEffect in statuses.keys():
		if status.is_negative == true:
			return true
	return false
