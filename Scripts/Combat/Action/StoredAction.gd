## Stores an action for a character in a battle.
class_name StoredAction extends Resource

## The character performing the action.
var activator: Combatant

var damage_datas: Array[DamageData] = []

## The characters that will targeted by the character performing their action.
var recipients: Array[Combatant] = []

## The kind of action. Helps with targeting.
var action_type: ActionTypes.ActionTypes

## The attached skill, if any.
var skill_data: SkillData = null

## How many times this action will be performed.
var num_activations: int = 1

var heal_amount: int = 0

## The status effects that will be applied.
## {status effect : the success chance}
var status_effects_to_apply: Dictionary = {}

func set_targets(targets: Array[Combatant]) -> void:
	recipients.append_array(targets)

func get_targets() -> Array[Combatant]:
	return recipients

func get_total_possible_damage() -> int:
	var total_pd: int = 0
	for dd: DamageData in damage_datas:
		total_pd += dd.damage_amount
	return total_pd
