## Responsible for managing combat.
class_name BattleController extends StateMachine

## The actions that will be performed during the next resolve phase.
var current_turn_actions: Array[StoredAction] = []

var active_enemies: Array[EnemyCombatant] = []

func set_me_up() -> void:
	# Connect to the event bus so we can now when a battle should start
	Eventbus.start_battle.connect( _on_battle_start )
	Eventbus.hp_depleted.connect( _on_hp_depleted )
	super()

func _on_battle_start(enemy_party_data: EnemyPartyData) -> void:
	# TODO: Checks to see if a battle is already under way.
	
	# Time to start the battle
	change_to_state(
		"BattleStart",
		{enemy_party_data = enemy_party_data}
	)

func _on_hp_depleted(com: Combatant) -> void:
	if com is EnemyCombatant:
		active_enemies.erase(com)

func add_actions(actions_to_add: Array[StoredAction]) -> void:
	current_turn_actions.append_array(actions_to_add)
