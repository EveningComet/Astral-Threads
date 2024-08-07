## A version of the combatant component that keeps track of data relevant to
## player characters.
class_name PlayerCombatant extends Combatant

var char_name: String:
	get: return char_name
	set(value):
		char_name = value

# TODO: Multiclassing.
var curr_job: Job
