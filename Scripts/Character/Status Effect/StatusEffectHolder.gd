## Container for a character's status effects.
class_name StatusEffectHolder extends Resource

## {status effect : turns left}
var statuses: Dictionary = {}

## The character being kept track of.
var combatant: Combatant

func _init(_com: Combatant) -> void:
	combatant = _com

## Are there status effects considered negative?
func has_negative_statuses_present() -> bool:
	for status: StatusEffect in statuses.keys():
		if status.is_negative == true:
			return true
	return false
