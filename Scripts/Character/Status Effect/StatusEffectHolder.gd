## Container for a character's status effects.
class_name StatusEffectHolder extends Resource

## The character being kept track of.
var combatant: Combatant

func _init(_com: Combatant) -> void:
	combatant = _com
