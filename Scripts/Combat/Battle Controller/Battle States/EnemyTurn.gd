## All the things related to enemy turns.
class_name EnemyTurn extends BattleState

func enter(msgs: Dictionary = {}) -> void:
	if OS.is_debug_build() == true:
		print("EnemyTurn :: Entered.")
	
	decide_actions()

func decide_actions() -> void:
	var actions: Array[StoredAction] = []
	var enemies_to_process: Array[EnemyCombatant] = my_state_machine.active_enemies
	
	for enemy: Combatant in enemies_to_process:
		var action: StoredAction = _get_action(
			enemy,
			enemies_to_process,
			PlayerPartyController.get_targetable_party()
		)
		
		actions.append(action)
	
	# Everything is done, time to go to the resolve phase
	my_state_machine.add_actions( actions )
	my_state_machine.change_to_state("ResolveTurn")

## Get an action for the enemy.
func _get_action(
	enemy: EnemyCombatant,
	allies,
	player_party: Array[PlayerCombatant]
) -> StoredAction:
	# Create the array that will store potential choices for an enemy
	var choices: Array[UtilityAIOption]
	
	# For each thing that an enemy can do, weigh their options
	for behavior: UtilityAIBehavior in enemy.enemy_data.behaviors:
		
		# Initialize a container that will house the calculations for the decisions
		var context: Dictionary = {
			"target_hp": 0,
			"defense":   0,
			"potential_damage": 0,
			"curr_sp": enemy.stats.get_curr_sp(),
			"skill_cost": 0,
			"healing_power": 0
		}
		
		# TODO: Make sure the enemy has enough sp for the skill.
		match behavior.name:
			# TODO: Convert these to enums
			"Attack Weakest":
				# TODO: Confusion/Possession?
				for com: Combatant in player_party:
					
					# Generate the stored action
					var potential_action: StoredAction = StoredAction.new()
					potential_action.activator = enemy
					potential_action.get_targets().append(com)
					
					context["target_hp"] = com.stats.get_curr_hp()
					context["defense"]   = com.stats.get_defense()
					
					# Find the skill that will deal the most damage
					for skill: SkillData in enemy.enemy_data.skills:
						potential_action.skill_data = skill
						potential_action = skill.get_usable_data(enemy, potential_action)
						potential_action.action_type = skill.action_type
						context["potential_damage"]
						
						# Finally, make the choice and it add it to the choices
						var choice = UtilityAIOption.new(
							behavior, context, potential_action
						)
						choices.append(choice)
			
			# TODO: Handling multiple targets.
			"Heal Ally":
				for enemy_ally: Combatant in allies:
					
					# Generate the stored action
					var potential_action: StoredAction = StoredAction.new()
					potential_action.activator = enemy
					potential_action.get_targets().append(enemy_ally)
					context["target_hp"] = enemy_ally.stats.get_curr_hp()
					
					for skill: SkillData in enemy.enemy_data.skills:
						potential_action.skill_data = skill
						potential_action.action_type = skill.action_type
						potential_action = skill.get_usable_data(enemy, potential_action)
						
						# If the skill doesn't benefit allies, throw it out
						if potential_action.heal_amount < 1:
							continue
						
						context["healing_power"] = potential_action.heal_amount
						var choice = UtilityAIOption.new(
							behavior, context, potential_action
						)
						choices.append( choice )
		
	# Get a decision based on how "smart" the enemy is
	var decision = UtilityAI.choose_highest(
		choices,
		enemy.enemy_data.efficiency
	)
	if OS.is_debug_build() == true:
		print_rich("[color=green]EnemyTurn :: Chosen decision: %s[/color]" % [decision])
	
	return decision.action as StoredAction

# TODO: Condense methods into here.
func _get_choices(activator: Combatant, behavior):
	var choices: Array[UtilityAIOption]
	pass
