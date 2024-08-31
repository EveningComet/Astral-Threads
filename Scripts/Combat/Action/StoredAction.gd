## Stores an action for a character in a battle.
class_name StoredAction extends Resource

## The character performing the action.
var activator: Combatant

## The characters that will targeted by the character performing their action.
var recipients: Array[Combatant] = []

var action_type: ActionTypes.ActionTypes

var num_activations: int = 1

func set_targets(targets: Array[Combatant]) -> void:
	recipients.append_array(targets)
