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
		printerr("ResolveTurn :: Player losing not implemented yet!")
		return
	
	if my_state_machine.active_enemies.size() == 0:
		my_state_machine.change_to_state("EndBattle")
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
	
	# Check if a new target needs to be found
	current_action = check_if_new_target_needed(current_action)
	
	# Run based on the number of activations
	for i: int in current_action.num_activations:
		
		# Check what needs to be done
		match current_action.action_type:
			
			# Get the required data
			ActionTypes.ActionTypes.AllEnemies, ActionTypes.ActionTypes.SingleEnemy:
				for target: Combatant in current_action.get_targets():
					if target != null:
						# TODO: Get the damage data from stats and so on.
						target.stats.take_damage(7)
						
						# TODO: Check for status effects to apply
						for effect: StatusEffect in current_action.status_effects_to_apply.keys():
							pass
				
			ActionTypes.ActionTypes.SingleAlly, ActionTypes.ActionTypes.AllAllies:
				for target: Combatant in current_action.get_targets():
					if target != null:
						target.stats.heal(current_action.heal_amount)
						
						# TODO: Check for status effects to apply
						for effect: StatusEffect in current_action.status_effects_to_apply.keys():
							pass
			
			# TODO: Implement proper fleeing. For now, just end the battle.
			ActionTypes.ActionTypes.Flee:
				my_state_machine.change_to_state("EndBattle")
				return
	
	await apply_changes()
	
	# Everything for this action is finished, move onto the next one
	next_action()

func check_if_new_target_needed(action: StoredAction) -> StoredAction:
	# Try to look for a new enemy target
	if action.action_type == ActionTypes.ActionTypes.SingleEnemy:
		var activator = action.activator
		var battle_participants: Array[Combatant] = get_all_active_combatants()
		if action.get_targets()[0] == null:
			for bp in battle_participants:
				if (activator is EnemyCombatant and bp is PlayerCombatant) or \
				(activator is PlayerCombatant and bp is EnemyCombatant):
					action.recipients[0] = bp
					break
		return action
	
	# The targets for everything else doesn't matter
	else:
		return action

## Returns a more filled out action.
func get_usable_data(current_action: StoredAction):
	var has_skill: bool = current_action.skill_data != null
	if has_skill == true:
		# TODO: Get the chance to hit.
		current_action.activator.stats.remove_sp(current_action.skill_data.base_cost)
	
	else:
		# Get some normal damage
		pass
	return 0

## This is where the animations, damage, and so on should truly be performed.
func apply_changes() -> void:
	# TODO: Perform the animations, do the damage, etc.
	await get_tree().create_timer(0.5, false, true).timeout

## Sort the actions based on the fastest characters.
func sort_actions_based_on_activator_speed(a: StoredAction, b: StoredAction) -> bool:
	var a_speed = a.activator.stats.stats[StatHelper.StatTypes.Speed].get_calculated_value()
	var b_speed = b.activator.stats.stats[StatHelper.StatTypes.Speed].get_calculated_value()
	return a_speed < b_speed
