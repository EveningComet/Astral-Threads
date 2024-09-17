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
		var action: StoredAction = _get_best_action(
			enemy,
			enemies_to_process,
			PlayerPartyController.get_targetable_party()
		)
		
		actions.append(action)
	
	# Everything is done, time to go to the resolve phase
	my_state_machine.add_actions( actions )
	my_state_machine.change_to_state("ResolveTurn")

## Get an action for the enemy.
func _get_best_action(
	enemy: EnemyCombatant,
	allies,
	player_party: Array[PlayerCombatant]
) -> StoredAction:
	# Create the array that will store potential choices for an enemy
	var choices: Array[UtilityAIOption]
	
	# For each thing that an enemy can do, weigh their options
	for behavior: UtilityAIBehavior in enemy.enemy_data.behaviors:
		# Initialize the data so that we can see what we're doing.
		var context: Dictionary = {
			"target_hp": 0
		}
	
	# Get a decision based on how "smart" the enemy is
	var decision = UtilityAI.choose_highest(
		choices,
		enemy.enemy_data.efficiency
	)
	return decision.action
