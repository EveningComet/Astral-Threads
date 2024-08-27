## The state where the game resolves the actions.
class_name ResolveTurn extends BattleState

var actions_to_execute: Array[StoredAction]

## Random number generator for calculating chances and the like.
var prng: RandomNumberGenerator = RandomNumberGenerator.new()

func enter(msgs: Dictionary = {}) -> void:
	# TODO: Properly implement the resolve turn.
	execute_actions()

func exit() -> void:
	actions_to_execute.clear()

func execute_actions() -> void:
	# First, do all the setup
	prng.randomize()
	actions_to_execute.append_array(my_state_machine.current_turn_actions)
	actions_to_execute.sort_custom( sort_actions_based_on_activator_speed )
	my_state_machine.current_turn_actions.clear()
	
	# Now, go through all the actions
	next_action()

## Recursive method that goes through the actions.
func next_action() -> void:
	
	# Checking to see which side won
	if PlayerPartyController.is_party_fightable() == false:
		# TODO: Handle the player losing
		return
	
	if my_state_machine.active_enemies.size() == 0:
		# TODO: Handle the player winning
		return
	
	# There are no more actions to execute, so go on to the next turn
	if actions_to_execute.size() == 0:
		# TODO: Move onto the next turn
		my_state_machine.change_to_state("PlayerTurn")
		return
	
	# Perform the next action
	var current_action: StoredAction = actions_to_execute.pop_front()
	execute_action(current_action)

func execute_action(current_action: StoredAction) -> void:
	var activator: Combatant = current_action.activator
	
	# Safety check for making sure the activator still exists
	if activator == null or activator.stats.get_curr_hp() <= 0:
		next_action()
		return
	
	# TODO: Check if a new target needs to be found for a single target
	
	# Run based on the number of activations
	for i: int in current_action.num_activations:
		
		# Check what needs to be done
		match current_action.action_type:
			
			# Get the required data
			ActionTypes.ActionTypes.AllEnemies, ActionTypes.ActionTypes.SingleEnemy:
				pass
				
			ActionTypes.ActionTypes.SingleAlly, ActionTypes.ActionTypes.AllAllies:
				pass
	
	await apply_changes()
	
	# Everything for this action is finished, move onto the next one
	next_action()

## This is where the animations, damage, and so on should truly be performed.
func apply_changes() -> void:
	# TODO: Perform the animations, do the damage, etc.
	await get_tree().create_timer(0.5, false, true).timeout

## Sort the actions based on the fastest characters.
func sort_actions_based_on_activator_speed(a: StoredAction, b: StoredAction) -> bool:
	var a_speed = a.activator.stats.stats[StatHelper.StatTypes.Speed].get_calculated_value()
	var b_speed = b.activator.stats.stats[StatHelper.StatTypes.Speed].get_calculated_value()
	return a_speed < b_speed
