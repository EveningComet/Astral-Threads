## Controls how the player does things while in the battle state.
class_name PlayerBattleController extends StateMachine

## The player's currently controlled characters.
var party_members_to_go_through: Array[Combatant] = []

## The current combatant the character is deciding an action for.
var curr_combatant: Combatant

## Stores the selected actions for characters in a key value pair.
## The character will be the key, their action will be the value.
var stored_actions:   Dictionary = {}

## Stores the previously selected action for each character for convenience.
var previous_actions: Dictionary = {}

## Used to keep track of which character is active.
var curr_combatant_idx: int = 0

func _unhandled_input(event: InputEvent) -> void:
	curr_state.check_for_unhandled_input(event)

func setup_for_new_turn() -> void:
	stored_actions.clear()
	
	# TODO: Get the summons?
	for pm: Combatant in PlayerPartyController.get_party():
		if pm != null and pm.stats.get_curr_hp() > 0:
			party_members_to_go_through.append(pm)
	
	curr_combatant_idx = 0
	curr_combatant     = party_members_to_go_through[curr_combatant_idx]

func end_of_turn_cleanup() -> void:
	party_members_to_go_through.clear()

## Store the action and the combatant so that it may passed later on to the
## battle controller.
func store_action(combatant: Combatant, action: StoredAction) -> void:
	previous_actions[combatant] = action
	stored_actions[combatant]   = action

func advance_to_next_character() -> void:
	curr_combatant_idx += 1
	curr_combatant      = party_members_to_go_through[curr_combatant_idx]

func return_to_previous_character() -> void:
	curr_combatant_idx -= 1
	curr_combatant_idx = max(curr_combatant_idx, 0)
	curr_combatant     = party_members_to_go_through[curr_combatant_idx]

## Return the stored action dictionary as a list.
func get_actions() -> Array[StoredAction]:
	var actions: Array[StoredAction] = []
	for a: StoredAction in stored_actions.values():
		actions.append(a)
	return actions

## Returns true or false dependong on whether or not the player still has to
## select actions for their characters.
func has_finished_selecting_needed_actions() -> bool:
	return stored_actions.size() == party_members_to_go_through.size()
